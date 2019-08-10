class ProximoGrado < ApplicationRecord
  has_many :inscripcion

  belongs_to :grado
end
