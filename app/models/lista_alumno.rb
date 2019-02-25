class ListaAlumno < ApplicationRecord
  belongs_to :lista
  belongs_to :alumno
end
