module FinleapNearby
  module Hash
    def slice(*keys)
      ::Hash[[keys, self.values_at(*keys)].transpose]
    end
  end
end
Hash.include FinleapNearby::Hash unless Hash.new.respond_to?("slice")
