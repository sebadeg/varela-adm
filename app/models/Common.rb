class Common

  def self.decimal_to_string(value,places)
  	if value == nil
  		return ""
	return sprintf("%0.02f", value).sub(/\.?0+$/, '')
  end

end
