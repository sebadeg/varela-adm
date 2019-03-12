class PadreAlumno < ApplicationRecord
  belongs_to :alumno
  belongs_to :usuario
end
