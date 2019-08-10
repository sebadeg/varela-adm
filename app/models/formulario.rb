class Formulario < ApplicationRecord
  has_many :formulario_inscripcion_opcion, :dependent => :delete_all
  accepts_nested_attributes_for :formulario_inscripcion_opcion, allow_destroy: true
end
