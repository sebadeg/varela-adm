class PadreAlumno < ApplicationRecord
  belongs_to :alumno
  belongs_to :usuario

  def alumno_nombre_tostr
  	return alumno != nil ? "#{alumno.tostr()}" : ""
  end

  def usuario_nombre_tostr
  	return usuario != nil ? "#{usuario.tostr()}" : ""
  end

end
