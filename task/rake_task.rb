require_relative "../lib/finleap_nearby"

namespace "finleap_nearby" do
  desc "Find the nearby customers from dataset"
  task :customers, [:radius, :radius_unit] do |t, args|
    ::FinleapNearby.config_defaults

    args.with_defaults(
        :radius => ::FinleapNearby.configuration.search_radius,
        :radius_unit => ::FinleapNearby.configuration.search_radius_unit
    )

    customers = ::FinleapNearby::Customers.new(
        search_radius:      args.radius,
        search_radius_unit: args.radius_unit
    ).calculate.customers

    message = "found within the radius #{args.radius}#{args.radius_unit}"
    unless customers.empty?
      puts "#{customers.size} customer#{customers.size > 1 ? "s" : "" } #{message}"
      puts customers
    else
      puts "No customer #{message}"
    end
  end
end