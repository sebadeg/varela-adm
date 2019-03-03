class Actividad < ApplicationRecord

  has_many :actividad_archivo, :dependent => :delete_all
  accepts_nested_attributes_for :actividad_archivo, allow_destroy: true

  has_many :actividad_opcion, :dependent => :delete_all
  accepts_nested_attributes_for :actividad_opcion, allow_destroy: true

  has_many :actividad_lista, :dependent => :delete_all
  accepts_nested_attributes_for :actividad_lista, allow_destroy: true

  has_many :actividad_alumno, :dependent => :delete_all
  accepts_nested_attributes_for :actividad_alumno, allow_destroy: true

  # def importar(attrs)
  #   p "Seba"
  #   p attrs

  #   self.nombre = attrs[:nombre]
  #   self.descripcion = attrs[:descripcion]
  #   self.fechainfo = attrs[:fechainfo]
  #   self.fecha = attrs[:fecha]
  #   if self.archivo == nil
  #     self.archivo = ""
  #   end

  #   if attrs[:archivo] != nil
  #     file = attrs[:archivo]
  #     self.archivo = attrs[:archivo].original_filename
  #     self.data = file.read
  #   end  	

  #   if !self.save 
  #     return false
  #   end

  # 	return true
  # end
end
