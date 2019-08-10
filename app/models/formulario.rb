class Formulario < ApplicationRecord
  has_many :formulario_inscripcion_opcion, :dependent => :delete_all
  accepts_nested_attributes_for :formulario_inscripcion_opcion, allow_destroy: true

  scope :todos, -> { all }
  scope :corrientes, -> { where("anio IN (SELECT anio_inscripciones FROM configs WHERE NOT anio_inscripciones IS NULL)") }

  def precio_total
  	return "100.0"
  end

end
