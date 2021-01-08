require_relative "../lib/lorem_ipsum_nearby"

namespace "lorem_ipsum_nearby" do
  desc "Find the nearby customers from dataset"
  task :customers, [:radius, :radius_unit, :result_sort_by] do |_, args|
    args.with_defaults(
      radius: ::LoremIpsumNearby.config.search_radius,
      radius_unit: ::LoremIpsumNearby.config.search_radius_unit,
      result_sort_by: ::LoremIpsumNearby.config.result_sort_by
    )

    # noinspection RubyResolve
    customers = ::LoremIpsumNearby::Customers.new(
      search_radius: args.radius,
      search_radius_unit: args.radius_unit
    ).filter_and_sort("distance").customers(%w[user_id name distance])

    # noinspection RubyResolve
    message = "found within the radius #{args.radius}#{args.radius_unit}"
    if customers.empty?
      puts "No customer #{message}"
    else
      puts "#{customers.size} customer#{customers.size > 1 ? "s" : ""} #{message}"
      puts customers
    end
  end
end
