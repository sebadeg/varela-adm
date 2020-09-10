class Hermanos2020 < ApplicationRecord

  def toString()
    return "#{nombre} #{sprintf( "%0.02f", descuento)}%";
  end

end
