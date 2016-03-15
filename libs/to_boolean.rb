module ToBoolean
  refine String do
    def to_bool
      return true if self == true || self.to_s.strip =~ /^(true|yes|y|1|t)$/i
      false
    end
  end
end
