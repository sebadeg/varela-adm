class ActividadAlumno < ApplicationRecord

  belongs_to :actividad
  belongs_to :alumno

	def opciones
		opciones = Array.new
		elecciones = Hash.new

		autorizar = AactividadOpcion.where(["aactividad_id = ? AND importe>0",aactividad_id]).first rescue nil		

		AactividadOpcion.where(["aactividad_id = ?",aactividad_id]).order(:cuotas).each do |s|
			if s.valor == 0
				if s.opcion != nil && s.opcion != ""
					o = s.opcion
					e = s.eleccion
				elsif autorizar == nil
					o = "No inscribir"
					e = "No está inscripto"
				else
					o = "No autorizo"
					e = "No está autorizado"
				end
				opciones.push( [o,s.valor] )
				elecciones[s.valor] = e
			else
				if s.opcion != nil && s.opcion != ""
					o = s.opcion
					e = s.eleccion
				elsif autorizar == nil 
					o = "Inscribir"
					e = "Está inscripto"
				elsif s.cuotas == 1
					o = "Autorizo a debitar contado de $U #{s.importe}"
					e = "Está autorizado el débito contado de $U #{s.importe}"
				else 
					o = "Autorizo a debitar en #{s.cuotas} cuotas de $U #{s.importe}"
					e = "Está autorizado el débito en #{s.cuotas} cuotas de $U #{s.importe}"
				end
				opciones.push( [o,s.valor] )
				elecciones[s.valor] = e
			end
		end
		return { :opciones => opciones, :elecciones => elecciones }
	end
end
