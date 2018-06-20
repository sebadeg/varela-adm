class PagoCuenta < ApplicationRecord
  belongs_to :cuenta

  scope :todos, -> { all }
  scope :sin_cuenta, -> { where(cuenta_id: nil) }

end
