class Inscripcion2020 < ApplicationRecord
  belongs_to :alumno
  belongs_to :padre, :class_name => "Usuario"
  belongs_to :madre, :class_name => "Usuario"
  belongs_to :titular1, :class_name => "Usuario"
  belongs_to :titular2, :class_name => "Usuario"
  belongs_to :grado
  belongs_to :proximo_grado
  belongs_to :formulario2020
  belongs_to :convenio2020
  belongs_to :afinidad2020
  belongs_to :matricula2020
  belongs_to :hermanos2020
  belongs_to :cuota2020

  scope :inscripcion, -> { where("NOT reinscripcion") }
  scope :reinscripcion, -> { where("reinscripcion") }


end
