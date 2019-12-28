class CuentaAlumno < ApplicationRecord
  belongs_to :cuenta
  belongs_to :alumno

  def cuenta_nombre_tostr
  	return cuenta != nil ? "#{cuenta.tostr()}" : ""
  end

  def alumno_nombre_tostr
  	return alumno != nil ? "#{alumno.tostr()}" : ""
  end

end
