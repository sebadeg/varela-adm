class Cuota2020 < ApplicationRecord
  has_many :linea_cuota2020, :dependent => :delete_all
  accepts_nested_attributes_for :linea_cuota2020, allow_destroy: true

  def toString()
    return "#{nombre}";
  end

end
