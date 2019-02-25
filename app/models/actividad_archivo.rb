class ActividadArchivo < ApplicationRecord
  belongs_to :actividad, dependent: :destroy
end
