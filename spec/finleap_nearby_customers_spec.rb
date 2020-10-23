RSpec.describe FinleapNearby::Customers do

  before do
    ::FinleapNearby.configure do |config|
      config.search_radius = 100
      config.search_radius_unit = :km
    end
    @valid_data_file_path   = ::FinleapNearby.configuration.data_file_path
    @invalid_customers_file = "spec/data/invalid_customers_file.json"
    @invalid_customers_data = "spec/data/invalid_customers_data.json"
  end

  describe "#initialize" do
    context "argument validations" do

      context "invalid arguments" do
        it "that has invalid data file path" do
          expect {
            ::FinleapNearby::Customers.new(data_file_path: 'data/invalid_file_path.json')
          }.to raise_error(::FinleapNearby::InvalidFilePath)
        end

        it "that has invalid search radius" do
          expect {
            ::FinleapNearby::Customers.new(search_radius: -10)
          }.to raise_error(::FinleapNearby::InvalidParams, /Invalid search radius =/)
        end

        it "that has invalid search radius unit" do
          expect {
            ::FinleapNearby::Customers.new(search_radius_unit: :kmm)
          }.to raise_error(::FinleapNearby::InvalidParams, /Invalid search radius unit =/)
        end

      end


      context "valid arguments" do
        it "that has valid path" do
          expect { ::FinleapNearby::Customers.new(data_file_path: @valid_data_file_path) }.not_to raise_error
        end

        it "that has valid search radius" do
          expect { ::FinleapNearby::Customers.new(search_radius: 10) }.not_to raise_error
        end

        it "that has valid search radius unit" do
          expect { ::FinleapNearby::Customers.new(search_radius_unit: :mi) }.not_to raise_error
        end

      end
    end
  end

  describe "data file validations" do
    context "parse data" do

      it "that has valid customer data" do
        expect do
          File.foreach(@valid_data_file_path) do |customer|
            JSON.parse(customer)
          end
        end.not_to raise_error
      end

      it "that has invalid customer data" do
        expect do
          File.foreach(@invalid_customers_file) do |customer|
            JSON.parse(customer)
          end
        end.to raise_error(JSON::ParserError)
      end
    end
  end

  describe ".valid_keys?" do
    context "customer data keys validation" do
      it "that has valid customer data keys" do
        expect do
          File.foreach(@valid_data_file_path) do |customer|
            raise ::FinleapNearby::RequiredDataMissing, "Required data key missing" unless ::FinleapNearby::Customers.valid_keys?(JSON.parse(customer))
          end
        end.not_to raise_error
      end

      it "that has invalid customer data keys" do
        expect do
          File.foreach(@invalid_customers_data) do |customer|
            raise ::FinleapNearby::RequiredDataMissing, "Required data key missing" unless ::FinleapNearby::Customers.valid_keys?(JSON.parse(customer))
          end
        end.to raise_error(::FinleapNearby::RequiredDataMissing)
      end
    end
  end

  describe "#calculate" do
    context "validate nearby customer data" do
      context "center point for berlin office (52.508283, 13.329657)" do

        it "that has correct customers for 100 km radius" do
          expected_customers = [
              { "user_id" => 4, "name" => "Ernesto Breitenberg" },
              { "user_id" => 6, "name" => "Nolan Little" },
              { "user_id" => 14, "name" => "Burt Klein Esq." },
              { "user_id" => 19, "name" => "Eldridge Funk DDS" },
              { "user_id" => 25, "name" => "Maggie Trantow" },
              { "user_id" => 29, "name" => "Arden Kshlerin" },
              { "user_id" => 30, "name" => "Candi Larkin" },
              { "user_id" => 35, "name" => "Blondell Hermiston" },
              { "user_id" => 36, "name" => "Kemberly Durgan DC" },
              { "user_id" => 40, "name" => "Rafael Streich IV" },
              { "user_id" => 42, "name" => "Raymundo Schuster" },
              { "user_id" => 49, "name" => "Cole Predovic JD" }
          ]
          expect do
            actual_customers = ::FinleapNearby::Customers.new.calculate.customers
            expect(actual_customers).to eql(expected_customers)
          end.not_to raise_error
        end

        it "that has correct customers for 50 km radius" do
          expected_customers = [{ "user_id" => 6, "name" => "Nolan Little" }]
          expect do
            actual_customers = ::FinleapNearby::Customers.new(search_radius: 50).calculate.customers
            expect(actual_customers).to eql(expected_customers)
          end.not_to raise_error
        end

        it "that has no customer for 20 km radius" do
          expected_customers = []
          expect do
            actual_customers = ::FinleapNearby::Customers.new(search_radius: 20).calculate.customers
            expect(actual_customers).to eql(expected_customers)
          end.not_to raise_error
        end

        it "no outside customers of 100 km radius should be found in the results" do
          outside_customers = { "user_id" => 3, "name" => "Mary Pacocha III" }
          expect do
            actual_customers = ::FinleapNearby::Customers.new(search_radius: 100).calculate.customers
            expect(actual_customers).not_to include(outside_customers)
          end.not_to raise_error
        end
      end
    end

  end
end
