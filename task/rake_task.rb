require_relative "../lib/finleap_nearby"

namespace "finleap_nearby" do
  desc "Find the nearby customers from dataset"
  task :customers, [:radius, :radius_unit] do |t, args|
    args.with_defaults(:radius => 100, :radius_unit => :km)

    customers = ::FinleapNearby::Customers.new(
        search_radius:      args.radius,
        search_radius_unit: args.radius_unit
    ).calculate.customers

    unless customers.empty?
      puts "#{customers.size} customer#{customers.size > 1 ? "s" : "" } found in the radius #{args.radius}#{args.radius_unit}"
      puts customers
    else
      puts "No customer found in the radius #{args.radius}#{args.radius_unit}"
    end
  end
end