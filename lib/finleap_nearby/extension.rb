module FinleapNearby
  module Hash
    def slice(*keys)
      ::Hash[[keys, values_at(*keys)].transpose]
    end
  end
end
Hash.include FinleapNearby::Hash unless {}.respond_to?("slice")
