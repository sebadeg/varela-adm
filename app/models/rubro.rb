class Rubro < ApplicationRecord
  belongs_to :tipo_rubro

  def nombre_clase()
  	return "Rubro"
  end

  def tostr()
  	return "#{id} - #{nombre}" 
  end

  def self.coleccion()
  	return Rubro.all.order(:nombre).map{|u| [u.tostr(),u.id]} 
  end

  def tipo_rubro_tostr
  	return tipo_rubro != nil ? tipo_rubro.tostr() : ""
  end


end
