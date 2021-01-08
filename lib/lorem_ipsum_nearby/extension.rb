module LoremIpsumNearby
  module Hash
    def slice(*keys)
      ::Hash[[keys, values_at(*keys)].transpose]
    end
  end
end
Hash.include LoremIpsumNearby::Hash unless {}.respond_to?("slice")
