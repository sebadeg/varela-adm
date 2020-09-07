class Matricula2020 < ApplicationRecord

  has_many :matricula2020_alumno, :dependent => :delete_all
  accepts_nested_attributes_for :matricula2020_alumno, allow_destroy: true

  has_many :linea_matricula2020, :dependent => :delete_all
  accepts_nested_attributes_for :linea_matricula2020, allow_destroy: true

  has_many :matricula2020_proximo_grado, :dependent => :delete_all
  accepts_nested_attributes_for :matricula2020_proximo_grado, allow_destroy: true

  def toString()
    return "#{nombre}";
  end

end
