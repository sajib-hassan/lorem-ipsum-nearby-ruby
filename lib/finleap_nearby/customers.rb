module FinleapNearby
  class Customers

    attr_reader :customers

    def initialize(search_radius: nil, search_radius_unit: nil, data_file_path: nil, center_point: nil)
      ::FinleapNearby.config_defaults

      @search_radius      = search_radius || ::FinleapNearby.configuration.search_radius
      @search_radius_unit = search_radius_unit || ::FinleapNearby.configuration.search_radius_unit
      @data_file_path     = data_file_path || ::FinleapNearby.configuration.data_file_path
      @center_point       = center_point || ::FinleapNearby.configuration.center_point

      @search_radius      = @search_radius.to_f
      @search_radius_unit = @search_radius_unit.to_sym
      @customers          = []

      validate_params
    end


    def calculate(sorted_by = "user_id")
      filter_customers
      sort_customers(sorted_by)

      self
    end

    def self.valid_keys?(customer)
      (::FinleapNearby.configuration.customer_data_keys - customer.keys).empty?
    end

    private

    def validate_params
      raise ::FinleapNearby::InvalidParams, "Invalid search radius = #{@search_radius}" unless @search_radius > 0.0
      raise ::FinleapNearby::InvalidParams, "Invalid search radius unit = #{@search_radius_unit}" unless [:km, :mi].include?(@search_radius_unit)
      raise ::FinleapNearby::InvalidFilePath, "Invalid file path = #{@data_file_path}" unless File.exist?(@data_file_path)
    end

    def filter_customers
      File.foreach(@data_file_path) do |customer|
        customer = JSON.parse(customer)

        raise ::FinleapNearby::RequiredDataMissing, "Required data key missing" unless ::FinleapNearby::Customers.valid_keys?(customer)

        @customers << customer.slice("user_id", "name") if @search_radius >= calculate_distance(customer)
      end
    end

    def calculate_distance(customer)
      ::FinleapNearby::GeoCalculator.distance(@center_point,
                                              [customer["latitude"], customer["longitude"]],
                                              { units: @search_radius_unit }
      )
    end

    def sort_customers(sort_by)
      @customers.sort_by! { |obj| obj[sort_by.to_s] }
    end

  end

end