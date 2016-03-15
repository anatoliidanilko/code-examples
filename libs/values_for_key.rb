module ValuesForKey
  refine Hash do
    def find_all_values_for(key)
      result = []
      result << self[key]

      values.each do |hash_value|
        result += hash_value.find_all_values_for(key) if hash_value.is_a? Hash
      end
      result.flatten.compact
    end
  end
end
