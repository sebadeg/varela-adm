class Common

  def self.decimal_to_string(value,places)
	return sprintf("%0.0#{places}}f", value).sub(/\.?0+$/, '')
  end

end
