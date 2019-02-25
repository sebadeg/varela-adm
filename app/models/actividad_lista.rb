class ActividadLista < ApplicationRecord
  belongs_to :actividad, dependent: :destroy
  belongs_to :lista, dependent: :destroy
end
