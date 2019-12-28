class TitularCuenta < ApplicationRecord
  belongs_to :cuenta
  belongs_to :usuario

  def cuenta_nombre_tostr
  	return cuenta != nil ? "#{cuenta.tostr()}" : ""
  end

  def usuario_nombre_tostr
  	return usuario != nil ? "#{usuario.tostr()}" : ""
  end

end
