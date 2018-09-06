class InscripcionAlumno < ApplicationRecord
  belongs_to :convenio
  belongs_to :alumno
end
