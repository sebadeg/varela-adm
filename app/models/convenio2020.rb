class Convenio2020 < ApplicationRecord

  def toString()
    return "#{nombre} #{'%.2f' % descuento}";
  end

end
