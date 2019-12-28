class Actividad < ApplicationRecord
  belongs_to :rubro

  has_many :actividad_archivo, :dependent => :delete_all
  accepts_nested_attributes_for :actividad_archivo, allow_destroy: true

  has_many :actividad_opcion, :dependent => :delete_all
  accepts_nested_attributes_for :actividad_opcion, allow_destroy: true

  has_many :actividad_lista, :dependent => :delete_all
  accepts_nested_attributes_for :actividad_lista, allow_destroy: true

  has_many :actividad_alumno, :dependent => :delete_all
  accepts_nested_attributes_for :actividad_alumno, allow_destroy: true

end
