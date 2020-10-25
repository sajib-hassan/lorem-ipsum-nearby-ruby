module FinleapNearby
  class Customers
    ##
    # Override the defaults value to match the customers
    # Accept named parameters
    #
    def initialize(search_radius: nil, search_radius_unit: nil, data_file_path: nil, center_point: nil)
      @search_radius = search_radius || ::FinleapNearby.config.search_radius
      @search_radius_unit = search_radius_unit || ::FinleapNearby.config.search_radius_unit
      @data_file_path = data_file_path || ::FinleapNearby.config.data_file_path
      @center_point = center_point || ::FinleapNearby.config.center_point

      @search_radius = @search_radius.to_f
      @search_radius_unit = @search_radius_unit.to_sym
      @customers = []

      validate_params
    end

    def self.valid_keys?(customer)
      (::FinleapNearby.config.required_data_keys - customer.keys).empty?
    end

    def validate_params
      raise ::FinleapNearby::InvalidParams, "Invalid search radius = #{@search_radius}" unless @search_radius > 0.0
      raise ::FinleapNearby::InvalidParams, "Invalid search radius unit = #{@search_radius_unit}" unless [:km, :mi].include?(@search_radius_unit)
      raise ::FinleapNearby::InvalidFilePath, "Invalid file path = #{@data_file_path}" unless File.exist?(@data_file_path)
    end

    ##
    # Filter customers within the radius and sort the result
    #
    def filter_and_sort(sort_by = nil)
      filter_customers
      sort_customers(sort_by)

      self
    end

    ##
    # Get the customers with the preferred data columns/keys
    #
    def customers(data_keys = nil)
      data_keys ||= ::FinleapNearby.config.result_data_keys
      @customers.map { |customer| customer.slice(*data_keys) }
    end

    ##
    # Filter customers within the radius
    #
    def filter_customers
      File.foreach(@data_file_path) do |customer|
        customer = JSON.parse(customer)

        raise ::FinleapNearby::RequiredDataMissing, "Required data key missing" unless ::FinleapNearby::Customers.valid_keys?(customer)

        distance = calculate_distance(customer)
        @customers << customer.merge({"distance" => distance}) if @search_radius >= distance
      end

      self
    end

    ##
    # Sort the customers within the provided column/key
    #
    def sort_customers(sort_by)
      sort_by ||= ::FinleapNearby.config.result_sort_by

      return [] if @customers.empty?
      raise ::FinleapNearby::InvalidSortKey, "Invalid sort key" unless @customers.first.has_key?(sort_by)

      @customers.sort_by! { |obj| obj[sort_by.to_s] }

      self
    end

    private

    ##
    # calculate distance of a customer from the center point
    #
    def calculate_distance(customer)
      ::FinleapNearby::GeoCalculator.distance(@center_point,
        [customer["latitude"], customer["longitude"]],
        {units: @search_radius_unit}).round(3)
    end
  end
end
