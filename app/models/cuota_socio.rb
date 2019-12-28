class CuotaSocio < ApplicationRecord
  belongs_to :socio

  def nombre_clase()
  	return "Cuota socio"
  end

  def tostr()
  	return "#{socio_nombre_tostr()} (#{General.fecha_corta(fecha)})" 
  end

  def socio_nombre_tostr()
  	return socio != nil ? "#{socio.tostr()}" : ""
  end

  def self.coleccion()
  	return Socio.all.order(:nombre,:apellido).map{|u| [u.tostr(),u.id]} 
  end

end
