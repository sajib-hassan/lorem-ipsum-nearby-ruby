RSpec.describe LoremIpsumNearby::Customers do
  before do
    ::LoremIpsumNearby.configure do |config|
      config.search_radius = 100
      config.search_radius_unit = :km
    end
    @valid_data_file_path = ::LoremIpsumNearby.config.data_file_path
    @invalid_customers_file = "spec/data/invalid_customers_file.json"
    @invalid_customers_data = "spec/data/invalid_customers_data.json"
  end

  describe "#initialize" do
    context "argument validations" do
      context "invalid arguments" do
        it "that has invalid data file path" do
          expect {
            ::LoremIpsumNearby::Customers.new(data_file_path: "data/invalid_file_path.json")
          }.to raise_error(::LoremIpsumNearby::InvalidFilePath)
        end

        it "that has invalid search radius" do
          expect {
            ::LoremIpsumNearby::Customers.new(search_radius: -10)
          }.to raise_error(::LoremIpsumNearby::InvalidParams, /Invalid search radius =/)
        end

        it "that has invalid search radius unit" do
          expect {
            ::LoremIpsumNearby::Customers.new(search_radius_unit: :kmm)
          }.to raise_error(::LoremIpsumNearby::InvalidParams, /Invalid search radius unit =/)
        end
      end

      context "valid arguments" do
        it "that has valid path" do
          expect { ::LoremIpsumNearby::Customers.new(data_file_path: @valid_data_file_path) }.not_to raise_error
        end

        it "that has valid search radius" do
          expect { ::LoremIpsumNearby::Customers.new(search_radius: 10) }.not_to raise_error
        end

        it "that has valid search radius unit" do
          expect { ::LoremIpsumNearby::Customers.new(search_radius_unit: :mi) }.not_to raise_error
        end
      end
    end
  end

  describe "data file validations" do
    context "parse data" do
      it "that has valid customer data" do
        expect {
          File.foreach(@valid_data_file_path) do |customer|
            JSON.parse(customer)
          end
        }.not_to raise_error
      end

      it "that has invalid customer data" do
        expect {
          File.foreach(@invalid_customers_file) do |customer|
            JSON.parse(customer)
          end
        }.to raise_error(JSON::ParserError)
      end
    end
  end

  describe ".valid_keys?" do
    context "customer data keys validation" do
      it "that has valid customer data keys" do
        expect {
          File.foreach(@valid_data_file_path) do |customer|
            raise ::LoremIpsumNearby::RequiredDataMissing, "Required data key missing" unless ::LoremIpsumNearby::Customers.valid_keys?(JSON.parse(customer))
          end
        }.not_to raise_error
      end

      it "that has invalid customer data keys" do
        expect {
          File.foreach(@invalid_customers_data) do |customer|
            raise ::LoremIpsumNearby::RequiredDataMissing, "Required data key missing" unless ::LoremIpsumNearby::Customers.valid_keys?(JSON.parse(customer))
          end
        }.to raise_error(::LoremIpsumNearby::RequiredDataMissing)
      end
    end
  end

  describe "#filter_customers" do
    context "filter customer data" do
      it "within 100km, unsorted" do
        expected_customers = [
          {"user_id" => 4, "name" => "Ernesto Breitenberg"}, {"user_id" => 19, "name" => "Eldridge Funk DDS"},
          {"user_id" => 30, "name" => "Candi Larkin"}, {"user_id" => 14, "name" => "Burt Klein Esq."},
          {"user_id" => 6, "name" => "Nolan Little"}, {"user_id" => 36, "name" => "Kemberly Durgan DC"},
          {"user_id" => 49, "name" => "Cole Predovic JD"}, {"user_id" => 25, "name" => "Maggie Trantow"},
          {"user_id" => 40, "name" => "Rafael Streich IV"}, {"user_id" => 29, "name" => "Arden Kshlerin"},
          {"user_id" => 35, "name" => "Blondell Hermiston"}, {"user_id" => 42, "name" => "Raymundo Schuster"}
        ]
        actual_customers = ::LoremIpsumNearby::Customers.new.filter_customers.customers
        expect(actual_customers).to eql(expected_customers)
      end
    end
  end

  describe "#sort_customers" do
    context "filter customer data and sort" do
      it "within 100km, sort by user_id" do
        expected_customers = [
          {"user_id" => 4, "name" => "Ernesto Breitenberg"},
          {"user_id" => 6, "name" => "Nolan Little"},
          {"user_id" => 14, "name" => "Burt Klein Esq."},
          {"user_id" => 19, "name" => "Eldridge Funk DDS"},
          {"user_id" => 25, "name" => "Maggie Trantow"},
          {"user_id" => 29, "name" => "Arden Kshlerin"},
          {"user_id" => 30, "name" => "Candi Larkin"},
          {"user_id" => 35, "name" => "Blondell Hermiston"},
          {"user_id" => 36, "name" => "Kemberly Durgan DC"},
          {"user_id" => 40, "name" => "Rafael Streich IV"},
          {"user_id" => 42, "name" => "Raymundo Schuster"},
          {"user_id" => 49, "name" => "Cole Predovic JD"}
        ]

        actual_customers = ::LoremIpsumNearby::Customers.new.filter_customers.sort_customers("user_id").customers
        expect(actual_customers).to eql(expected_customers)
      end
    end
  end

  describe "#filter_and_sort" do
    context "validate nearby customer data" do
      context "center point for berlin office (52.508283, 13.329657)" do
        it "that has correct customers for 100 km radius" do
          expected_customers = [
            {"user_id" => 4, "name" => "Ernesto Breitenberg"},
            {"user_id" => 6, "name" => "Nolan Little"},
            {"user_id" => 14, "name" => "Burt Klein Esq."},
            {"user_id" => 19, "name" => "Eldridge Funk DDS"},
            {"user_id" => 25, "name" => "Maggie Trantow"},
            {"user_id" => 29, "name" => "Arden Kshlerin"},
            {"user_id" => 30, "name" => "Candi Larkin"},
            {"user_id" => 35, "name" => "Blondell Hermiston"},
            {"user_id" => 36, "name" => "Kemberly Durgan DC"},
            {"user_id" => 40, "name" => "Rafael Streich IV"},
            {"user_id" => 42, "name" => "Raymundo Schuster"},
            {"user_id" => 49, "name" => "Cole Predovic JD"}
          ]
          actual_customers = ::LoremIpsumNearby::Customers.new.filter_and_sort.customers
          expect(actual_customers).to eql(expected_customers)
        end

        it "that has correct customers for 50 km radius" do
          expected_customers = [{"user_id" => 6, "name" => "Nolan Little"}]
          actual_customers = ::LoremIpsumNearby::Customers.new(search_radius: 50).filter_and_sort.customers
          expect(actual_customers).to eql(expected_customers)
        end

        it "that has no customer for 20 km radius" do
          expected_customers = []
          actual_customers = ::LoremIpsumNearby::Customers.new(search_radius: 20).filter_and_sort.customers
          expect(actual_customers).to eql(expected_customers)
        end

        it "no outside customers of 100 km radius should be found in the results" do
          outside_customers = {"user_id" => 3, "name" => "Mary Pacocha III"}
          actual_customers = ::LoremIpsumNearby::Customers.new(search_radius: 100).filter_and_sort.customers
          expect(actual_customers).not_to include(outside_customers)
        end
      end
    end
  end

  describe "#customers" do
    context "result data" do
      it "with default result keys [user_id, name]" do
        expected_customers = [
          {"user_id" => 4, "name" => "Ernesto Breitenberg"},
          {"user_id" => 6, "name" => "Nolan Little"},
          {"user_id" => 14, "name" => "Burt Klein Esq."},
          {"user_id" => 19, "name" => "Eldridge Funk DDS"},
          {"user_id" => 25, "name" => "Maggie Trantow"},
          {"user_id" => 29, "name" => "Arden Kshlerin"},
          {"user_id" => 30, "name" => "Candi Larkin"},
          {"user_id" => 35, "name" => "Blondell Hermiston"},
          {"user_id" => 36, "name" => "Kemberly Durgan DC"},
          {"user_id" => 40, "name" => "Rafael Streich IV"},
          {"user_id" => 42, "name" => "Raymundo Schuster"},
          {"user_id" => 49, "name" => "Cole Predovic JD"}
        ]

        actual_customers = ::LoremIpsumNearby::Customers.new.filter_and_sort.customers
        expect(actual_customers).to eql(expected_customers)
      end

      it "with customized result keys [user_id, name, distance]" do
        expected_customers = [
          {"user_id" => 4, "name" => "Ernesto Breitenberg", "distance" => 51.425},
          {"user_id" => 6, "name" => "Nolan Little", "distance" => 41.142},
          {"user_id" => 14, "name" => "Burt Klein Esq.", "distance" => 80.75},
          {"user_id" => 19, "name" => "Eldridge Funk DDS", "distance" => 51.483},
          {"user_id" => 25, "name" => "Maggie Trantow", "distance" => 70.169},
          {"user_id" => 29, "name" => "Arden Kshlerin", "distance" => 63.088},
          {"user_id" => 30, "name" => "Candi Larkin", "distance" => 89.476},
          {"user_id" => 35, "name" => "Blondell Hermiston", "distance" => 94.534},
          {"user_id" => 36, "name" => "Kemberly Durgan DC", "distance" => 91.655},
          {"user_id" => 40, "name" => "Rafael Streich IV", "distance" => 77.975},
          {"user_id" => 42, "name" => "Raymundo Schuster", "distance" => 56.608},
          {"user_id" => 49, "name" => "Cole Predovic JD", "distance" => 72.765}
        ]

        actual_customers = ::LoremIpsumNearby::Customers.new.filter_and_sort.customers(%w[user_id name distance])

        expect(actual_customers).to eql(expected_customers)
      end
    end
  end
end
