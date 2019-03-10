class ActividadAlumno < ApplicationRecord

  belongs_to :actividad
  belongs_to :alumno


  def elegir_opcion(opcion)
  	actividad = Actividad.find(actividad_id)
  	alumno = Alumno.find(alumno_id)

    movs = Movimiento.where("actividad_alumno_id=#{id} AND actividad_alumno_opcion<>#{opcion}") rescue nil
    if ( movs != nil && movs.count != 0 )
      movs.destroy_all
    end

    movs = Movimiento.where("actividad_alumno_id=#{id} AND actividad_alumno_opcion=#{opcion}") rescue nil
    if ( movs == nil || movs.count == 0 )
      cuenta_id = CuentaAlumno.where(alumno_id: alumno_id).first.cuenta_id
      actividad_opcion = ActividadOpcion.find(opcion)
      if actividad_opcion.fecha != nil 
        fecha = DateTime.new(actividad_opcion.fecha.year,actividad_opcion.fecha.month,1)
        if actividad_opcion.cuotas >= 1 
          (1..actividad_opcion.cuotas).each do |cuota|
            Movimiento.create(cuenta_id: cuenta_id, alumno: alumno_id, fecha: fecha + (cuota-1).month,
              descripcion: "#{actividad.nombre.upcase} #{cuota}/#{actividad_opcion.cuotas}" , extra: "", debe: actividad_opcion.importe,
              haber: 0, tipo: 1002, actividad_alumno_id: id, actividad_alumno_opcion: opcion )
          end
        end
      end
    end
  end


  def nombre_alumno
    a = Alumno.find(alumno_id) rescue nil
    if a == nil
    	return ""
    else
    	return a.nombre + " " + a.apellido
    end
  end

  def nombre_opcion
    return "Opcion"
  end

  def fecha_opcion
    return "Fecha"
  end


	def opciones
		opciones = Array.new
		elecciones = Hash.new

		autorizar = ActividadOpcion.where(["actividad_id = ? AND importe>0",actividad_id]).first rescue nil		

		ActividadOpcion.where(["actividad_id = ?",actividad_id]).order(:cuotas).each do |s|
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
