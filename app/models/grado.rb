class Grado < ApplicationRecord
  has_many :subgrado
  
  has_many :opcion, :dependent => :delete_all
  accepts_nested_attributes_for :opcion, allow_destroy: true

  def nombre_clase()
  	return "Grado"
  end

  def tostr()
  	return "#{nombre}" 
  end

  def self.coleccion()
  	return Grado.all.order(:nombre).map{|u| [u.tostr(),u.id]} 
  end
end
