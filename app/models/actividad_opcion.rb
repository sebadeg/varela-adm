class ActividadOpcion < ApplicationRecord
  belongs_to :actividad
  belongs_to :opcion_concepto

  def self.opcion_nombre(opcion)
    if opcion != nil 
      s = ""
      if opcion.opcion_concepto_id != nil  
        concepto = OpcionConcepto.find(opcion.opcion_concepto_id)
        s = concepto != nil ? concepto.nombre : ""
      end
      if ( opcion.cuotas != nil && opcion.cuotas > 0 )
        if ( opcion.cuotas == 1 )
          s = s + " a debitar contado de $U "
        else
          s = s + " a debitar en #{opcion.cuotas} cuotas de $U "
        end
        s = s + "#{opcion.importe}"
      end
      return s
    else
      return ""
    end
  end

  def self.opcion_nombre_by_id(id)
    opcion = ActividadOpcion.find(id) rescue nil
    return opcion_nombre(opcion)
  end


  def self.opciones(actividad_id)
    opciones = Array.new
    elecciones = Hash.new

    ActividadOpcion.where(["actividad_id=#{actividad_id}"]).order(:indice).each do |opcion|
      if (opcion.fecha == nil || opcion.fecha >= DateTime.now )
        s = opcion_nombre(opcion)
        opciones.push( [s,opcion.id] )
        elecciones[opcion.id] = s
      end
    end

    return { :opciones => opciones, :elecciones => elecciones }
  end

  def self.todas_opciones(actividad_id)
    opciones = Array.new
    elecciones = Hash.new

    ActividadOpcion.where(["actividad_id=#{actividad_id}"]).order(:indice).each do |opcion|
      s = opcion_nombre(opcion)
      opciones.push( [s,opcion.id] )
      elecciones[opcion.id] = s
    end

    return { :opciones => opciones, :elecciones => elecciones }
  end
end
