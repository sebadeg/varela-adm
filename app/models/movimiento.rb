class Movimiento < ApplicationRecord
  belongs_to :rubro

  scope :corrientes, -> { where("date_part('year', fecha)=2020") }
  scope :todos, -> { all }
  scope :sin_cuenta, -> { where("cuenta_id IS NULL") }

end
