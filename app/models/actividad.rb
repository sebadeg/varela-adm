class Actividad < ApplicationRecord
  has_many :actividad_lista, :dependent => :delete_all
  accepts_nested_attributes_for :actividad_lista, allow_destroy: true

  def importar(attrs)

    self.nombre = attrs[:nombre]
    self.descripcion = attrs[:descripcion]
    self.fechainfo = attrs[:fechainfo]
    self.fecha = attrs[:fecha]

  	if attrs[:archivo] != nil
	  	file = attrs[:archivo]
	    self.archivo = file.original_filename
	    self.data = file.read
	  end

    if !self.save 
      return false
    end

  	return true
  end
end
