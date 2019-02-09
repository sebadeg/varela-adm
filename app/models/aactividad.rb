class Aactividad < ApplicationRecord

  has_many :aactividad_archivo, :dependent => :delete_all
  accepts_nested_attributes_for :aactividad_archivo, allow_destroy: true

  has_many :aactividad_opcion, :dependent => :delete_all
  accepts_nested_attributes_for :aactividad_opcion, allow_destroy: true

  has_many :aactividad_lista, :dependent => :delete_all
  accepts_nested_attributes_for :aactividad_lista, allow_destroy: true

  has_many :aactividad_alumno, :dependent => :delete_all
  accepts_nested_attributes_for :aactividad_alumno, allow_destroy: true

end
