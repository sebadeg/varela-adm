class TitularCuenta < ApplicationRecord
  belongs_to :cuenta
  belongs_to :usuario
end
