class InscripcionOpcion < ApplicationRecord
  belongs_to :inscripcion_opcion_tipo

  has_many :inscripcion_opcion_cuota, :dependent => :delete_all
  accepts_nested_attributes_for :inscripcion_opcion_cuota, allow_destroy: true


  def nombre_completo
    s = ""
    if inscripcion_opcion_tipo != nil 
      s = inscripcion_opcion_tipo.nombre + ": "
    end
    s = s + nombre
    return s
  end

end
