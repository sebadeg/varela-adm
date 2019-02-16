class Cuenta < ApplicationRecord
  has_many :pago_cuenta
  has_many :recargo

  scope :todos, -> { all }
  scope :concurre, -> { where("concurre") }

end
