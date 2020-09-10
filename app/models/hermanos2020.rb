class Hermanos2020 < ApplicationRecord

  def toString()
    return "#{nombre} #{descuento.to_s("%.2f")}%";
  end

end
