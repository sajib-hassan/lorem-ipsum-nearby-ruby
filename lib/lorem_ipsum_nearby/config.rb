module LoremIpsumNearby
  class Config
    attr_writer :search_radius,
      :search_radius_unit,
      :data_file_path,
      :center_point,
      :result_sort_by,
      :result_data_keys

    # Matching customers within this radius
    def search_radius
      @search_radius ||= 100
    end

    # Matching customers within the radius in units, default is :km
    # Available options are -
    # - :km for Kilometer
    # - :mi for Mile
    def search_radius_unit
      @search_radius_unit ||= :km
    end

    # Customer data file. Which must be -
    # - Text file (`data/customers.json`)
    # - one customer data per line, JSON-encoded.
    def data_file_path
      @data_file_path ||= "data/customers.json".freeze
    end

    # Center point to match the customer's coordinate ([lat,lon])
    # The GPS coordinates for Berlin office are 52.508283, 13.329657
    def center_point
      @center_point ||= [52.508283, 13.329657].freeze
    end

    # Matched customers sort by
    def result_sort_by
      @result_sort_by ||= "user_id".freeze
    end

    # default result data keys of the matched customer data
    def result_data_keys
      @result_data_keys ||= %w[user_id name].freeze
    end

    # required data keys in the customer data file
    def required_data_keys
      %w[user_id name latitude longitude]
    end
  end
end
