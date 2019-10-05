class CuentaAlumno < ApplicationRecord
  belongs_to :cuenta
  belongs_to :alumno
end
