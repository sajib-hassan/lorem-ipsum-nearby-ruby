module FinleapNearby
  class Configuration
    attr_accessor :search_radius, :search_radius_unit, :data_file_path, :center_point, :result_sort_by, :result_data_keys

    # Customer data file. Which must be -
    # - Text file (`data/customers.json`)
    # - one customer data per line, JSON-encoded.
    DATA_FILE_PATH = "data/customers.json"

    # Matching customers within this radius
    SEARCH_RADIUS = 100

    # Matching customers within the radius in units, default is :km
    # Available options are -
    # - :km for Kilometer
    # - :mi for Mile
    SEARCH_RADIUS_UNIT = :km

    # Center point to match the customer's coordinate ([lat,lon])
    # The GPS coordinates for Berlin office are 52.508283, 13.329657
    CENTER_POINT = [52.508283, 13.329657]

    # Matched customers sort by
    RESULT_SORT_BY = "user_id"

    # default result data keys of the matched customer data
    DEFAULT_RESULT_DATA_KEYS = %w[user_id name]

    # required data keys in the customer data file
    REQUIRED_DATA_KEYS = %w[user_id name latitude longitude]

    def initialize
      @search_radius = SEARCH_RADIUS
      @search_radius_unit = SEARCH_RADIUS_UNIT
      @center_point = CENTER_POINT
      @data_file_path = DATA_FILE_PATH
      @result_sort_by = RESULT_SORT_BY
      @result_data_keys = DEFAULT_RESULT_DATA_KEYS
    end
  end
end
