class Movimiento < ApplicationRecord
  belongs_to :rubro

  scope :corrientes, -> { where("date_part('year', fecha) IN (SELECT anio FROM configs WHERE NOT anio IS NULL)") }
  scope :todos, -> { all }

end
