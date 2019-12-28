class TipoRubro < ApplicationRecord

  def nombre_clase()
  	return "Tipo rubro"
  end

  def tostr()
  	return "#{nombre}" 
  end

  def self.coleccion()
  	return TipoRubro.all.order(:nombre).map{|u| [u.tostr(),u.id]} 
  end

end
