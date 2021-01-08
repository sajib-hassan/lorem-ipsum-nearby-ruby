RSpec.describe LoremIpsumNearby::GeoCalculator do
  describe ".distance" do
    context "two points spherical distance" do
      it "in kilometers" do
        expect(111).to eq(::LoremIpsumNearby::GeoCalculator.distance([0, 0], [0, 1], units: :km).round)
        la_to_ny = ::LoremIpsumNearby::GeoCalculator.distance([34.05, -118.25], [40.72, -74], units: :km).round
        expect((la_to_ny - 3942).abs).to be < 10
      end

      it "in miles" do
        expect(69).to eq(::LoremIpsumNearby::GeoCalculator.distance([0, 0], [0, 1], units: :mi).round)
        la_to_ny = ::LoremIpsumNearby::GeoCalculator.distance([34.05, -118.25], [40.72, -74], units: :mi).round
        expect((la_to_ny - 2444).abs).to be < 10
      end

      it "customer correct distance" do
        customer = {
          "user_id" => 3,
          "name" => "Mary Pacocha III",
          "latitude" => 54.0653745433511,
          "longitude" => 15.175624975930294
        }
        distance_in_km = ::LoremIpsumNearby::GeoCalculator.distance(::LoremIpsumNearby.config.center_point,
          [customer["latitude"], customer["longitude"]],
          {units: :km})

        expect(distance_in_km).to be_within(0.01).of(212.20)
      end
    end
  end
end
