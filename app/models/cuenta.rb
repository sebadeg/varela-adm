class Cuenta < ApplicationRecord
  has_many :pago_cuenta
  has_many :recargo

  scope :todos, -> { all }
  scope :concurre, -> { where("concurre") }
  scope :brou, -> { where("brou") }
  scope :visa, -> { where("visa") }
  scope :oca, -> { where("oca") }

end
