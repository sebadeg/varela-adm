class ListaAlumno < ApplicationRecord
  belongs_to :lista, dependent: :destroy
  belongs_to :alumno, dependent: :destroy
end
