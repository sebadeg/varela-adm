class ProximoGrado < ApplicationRecord
  has_many :inscripcion

  belongs_to :grado

  scope :todos, -> { all }
  scope :corrientes, -> { where("anio IN (SELECT anio_inscripciones FROM configs WHERE NOT anio_inscripciones IS NULL)") }

  def nombre_clase()
    return "Próximo Grados"
  end

  def tostr()
    return "#{nombre} (#{anio})" 
  end

  def self.coleccion()
    return ProximoGrado.all.order(:nombre).map{|u| [u.tostr(),u.id]} 
  end

 
end
