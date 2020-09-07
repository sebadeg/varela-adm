class Cuota2020 < ApplicationRecord
  has_many :cuota2020_alumno, :dependent => :delete_all
  accepts_nested_attributes_for :cuota2020_alumno, allow_destroy: true

  has_many :linea_cuota2020, :dependent => :delete_all
  accepts_nested_attributes_for :linea_cuota2020, allow_destroy: true

  def toString()
    return "#{nombre}";
  end

end
