# LoremIpsum - Nearby Customers

**This is a gem for a Tech challenge** 

## The Tech Challenge
We have some customer records in a text file (`data/customers.json`) -- one customer data per line, JSON-encoded. We want to invite any customer within 100km of our X office for some food and drinks. 

Write a program that will `read the full list of customers` and output the `names and user ids` of matching customers (within `100km`), `sorted by User ID (ascending)`.

- You can use the `first formula` from [this Wikipedia article](https://en.wikipedia.org/wiki/Great-circle_distance) to
calculate distance. Don't forget, you'll need to `convert degrees to
radians`.
- The GPS coordinates for our `X office are 52.508283,
13.329657`
- You can find the Customer list [here](https://gist.github.com/xxxxxxxxx/aaaaaaaa).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lorem_ipsum_nearby'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install lorem_ipsum_nearby

## Usage

#### Configuration

This gem considered the `default values` as below under the `Config` class in `lib/lorem_ipsum_nearby/config.rb`.
But You can override these default values through initializers code in `your APP`.
```ruby
# config/initializers/lorem_ipsum_nearby.rb

::LoremIpsumNearby.configure do |config|
  # Customer data file. Which must be -
  # - Text file (default is `data/customers.json`)
  # - one customer data per line, JSON-encoded.
  config.data_file_path = "data/customers.json"

  # Matching customers within this radius
  # default is 100
  config.search_radius = 100

  # Matching customers within the radius in units, default is :km
  # Available options are -
  # - :km for Kilometer
  # - :mi for Mile
  config.search_radius_unit = :km

  # Center point to match the customer's coordinate ([lat,lon])
  # default center point is the GPS coordinates for Berlin office are 52.508283, 13.329657
  config.center_point = [52.508283, 13.329657]

  # Matched customers sort by
  # default is "user_id"
  config.result_sort_by = "user_id"

  # result data keys of the matched customer data and distance
  # for example %w[user_id name distance]
  # default is %w[user_id name]
  config.result_data_keys = %w[user_id name]
  
end 
```

#### Use Library - `lib/lorem_ipsum_nearby/customers.rb`

Get the matching customers data by this Gem with the default values and sort by `user_id` - 
```ruby
customers = ::LoremIpsumNearby::Customers.new.filter_and_sort.customers
puts customers
```

Output:
```ruby
{"user_id"=>4, "name"=>"Ernesto Breitenberg"}
{"user_id"=>6, "name"=>"Nolan Little"}
{"user_id"=>14, "name"=>"Burt Klein Esq."}
{"user_id"=>19, "name"=>"Eldridge Funk DDS"}
{"user_id"=>25, "name"=>"Maggie Trantow"}
{"user_id"=>29, "name"=>"Arden Kshlerin"}
{"user_id"=>30, "name"=>"Candi Larkin"}
{"user_id"=>35, "name"=>"Blondell Hermiston"}
{"user_id"=>36, "name"=>"Kemberly Durgan DC"}
{"user_id"=>40, "name"=>"Rafael Streich IV"}
{"user_id"=>42, "name"=>"Raymundo Schuster"}
{"user_id"=>49, "name"=>"Cole Predovic JD"}
```

Alternatively, with the `named` parameters to override the defaults. 
Also, you can sort the matched customer by passing a data key name (default is `user_id`). Valid sort key names are customer object keys, and `distance`. 
```ruby
customers = ::LoremIpsumNearby::Customers.new(
        search_radius:      50,
        search_radius_unit: :km,
        data_file_path: "data/customers.json", 
        center_point: [52.508283, 13.329657]
    ).filter_and_sort("user_id").customers(%w[user_id name distance])

puts customers
```

Output:
```ruby
{"user_id"=>6, "name"=>"Nolan Little", "distance"=>41.142}
```

#### Using `rake task` - `task/nearby_customers.rb`

You can run task `lorem_ipsum_nearby:customers` in the file `task/nearby_customers.rb` with the defaults and preferred result data keys `%w[user_id name distance]`. 
    
    $ rake lorem_ipsum_nearby:customers
    
Output:
```shell script
lorem_ipsum_nearby git:(main) $ rake lorem_ipsum_nearby:customers
12 customers found within the radius 100km
{"user_id"=>6, "name"=>"Nolan Little", "distance"=>41.142}
{"user_id"=>4, "name"=>"Ernesto Breitenberg", "distance"=>51.425}
{"user_id"=>19, "name"=>"Eldridge Funk DDS", "distance"=>51.483}
{"user_id"=>42, "name"=>"Raymundo Schuster", "distance"=>56.608}
{"user_id"=>29, "name"=>"Arden Kshlerin", "distance"=>63.088}
{"user_id"=>25, "name"=>"Maggie Trantow", "distance"=>70.169}
{"user_id"=>49, "name"=>"Cole Predovic JD", "distance"=>72.765}
{"user_id"=>40, "name"=>"Rafael Streich IV", "distance"=>77.975}
{"user_id"=>14, "name"=>"Burt Klein Esq.", "distance"=>80.75}
{"user_id"=>30, "name"=>"Candi Larkin", "distance"=>89.476}
{"user_id"=>36, "name"=>"Kemberly Durgan DC", "distance"=>91.655}
{"user_id"=>35, "name"=>"Blondell Hermiston", "distance"=>94.534}

```

    
Alternatively, you can also pass the search data (sequentially accepts radius, radius unit, and result sort by) in parameter. 

**Don't forget to enclosed with `"` while using parameters.** 

    $ rake "lorem_ipsum_nearby:customers[50,km,distance]"

**Output:**
```shell script
lorem_ipsum_nearby git:(main) $ rake "lorem_ipsum_nearby:customers[50,km,distance]" 
1 customer found within the radius 50km
{"user_id"=>6, "name"=>"Nolan Little", "distance"=>41.142}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
