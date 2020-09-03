class ProximoGrado < ApplicationRecord
  has_many :inscripcion

  belongs_to :grado

  scope :todos, -> { all }
  scope :corrientes, -> { where("anio IN (SELECT anio_inscripciones FROM configs WHERE NOT anio_inscripciones IS NULL)") }
 

  def toString()
  	return "#{nombre} - $U #{precio}"
  end

end
