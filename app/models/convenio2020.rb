class Convenio2020 < ApplicationRecord

  def toString()
    return "#{nombre} #{Common.decimal_to_string(descuento,2)}%";
  end

end
