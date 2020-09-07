class ProximoGrado < ApplicationRecord
  has_many :inscripcion

  has_many :matricula2020_proximo_grado
  accepts_nested_attributes_for :matricula2020_proximo_grado, allow_destroy: true

  belongs_to :grado

  scope :todos, -> { all }
  scope :corrientes, -> { where("anio IN (SELECT anio_inscripciones FROM configs WHERE NOT anio_inscripciones IS NULL)") }


  def toString()
  	return "#{nombre} - $U #{precio}"
  end

end
