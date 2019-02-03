class Cuenta < ApplicationRecord
  has_many :pago_cuenta
  belongs_to :recargo
end
