class ActividadOpcion < ApplicationRecord
  belongs_to :actividad, dependent: :destroy
end
