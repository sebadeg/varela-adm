class Cuenta < ApplicationRecord
  has_many :pago_cuenta
  has_many :recargo
end
