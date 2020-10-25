require_relative "lib/finleap_nearby/version"

Gem::Specification.new do |spec|
  spec.name = "finleap_nearby"
  spec.version = FinleapNearby::VERSION
  spec.authors = ["A T M Hassan Uzzaman"]
  spec.email = ["sajib.hassan@gmail.com"]

  spec.summary = "This is a gem for a Tech challenge for the position of (Senior) Ruby on Rails Engineer at finleap connect"
  spec.description = "We have some customer records in a text file (data/customers.json) -- one customer data per line, JSON-encoded. We want to invite any customer within 100km of our Berlin office for some food and drinks.

Write a program that will read the full list of customers and output the names and user ids of matching customers (within 100km), sorted by User ID (ascending).
- You can use the first formula from this Wikipedia article to calculate distance. Don't forget, you'll need to convert degrees to radians.
- The GPS coordinates for our Berlin office are 52.508283, 13.329657
- You can find the Customer list here - https://gist.github.com/flood4life/aa8fcb88243b6d96287c4b1dc63948de"
  spec.homepage = "https://github.com/sajib-hassan/finleap-nearby-ruby.git"
  spec.license = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://github.com/sajib-hassan/finleap-nearby-ruby.git"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/sajib-hassan/finleap-nearby-ruby.git"
  spec.metadata["changelog_uri"] = "https://github.com/sajib-hassan/finleap-nearby-ruby.git"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
