class Socio < ApplicationRecord

  scope :todos, -> { all }
  scope :activos, -> { where("fecha_egreso IS NULL AND (fecha_ingreso <= now() - interval '2 years')") }
  scope :suscriptores, -> { where("fecha_egreso IS NULL AND (fecha_ingreso > now() - interval '2 years')") }

  def nombre_clase()
  	return "Socio"
  end

  def tostr()
  	return "#{nombre} #{apellido}" 
  end

  def self.coleccion()
  	return Socio.all.order(:nombre,:apellido).map{|u| [u.tostr(),u.id]} 
  end

end
