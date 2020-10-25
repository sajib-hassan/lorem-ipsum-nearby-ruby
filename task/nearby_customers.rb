require_relative "../lib/finleap_nearby"

namespace "finleap_nearby" do
  desc "Find the nearby customers from dataset"
  task :customers, [:radius, :radius_unit, :result_sort_by] do |_, args|
    args.with_defaults(
      radius: ::FinleapNearby.config.search_radius,
      radius_unit: ::FinleapNearby.config.search_radius_unit,
      result_sort_by: ::FinleapNearby.config.result_sort_by
    )

    #noinspection RubyResolve
    customers = ::FinleapNearby::Customers.new(
      search_radius: args.radius,
      search_radius_unit: args.radius_unit
    ).filter_and_sort("distance").customers(%w[user_id name distance])

    #noinspection RubyResolve
    message = "found within the radius #{args.radius}#{args.radius_unit}"
    if customers.empty?
      puts "No customer #{message}"
    else
      puts "#{customers.size} customer#{customers.size > 1 ? "s" : ""} #{message}"
      puts customers
    end
  end
end
