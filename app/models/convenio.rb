class Convenio < ApplicationRecord
  has_many :alumnos, through: :inscripcion_alumno
end
