class Convenio2020 < ApplicationRecord

  def toString()
    if descuento != nil && descuento>0
      return "#{nombre} #{Common.decimal_to_string(descuento,2)}%";
    else
      return ""
    end
  end

end
