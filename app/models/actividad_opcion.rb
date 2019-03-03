class ActividadOpcion < ApplicationRecord
  belongs_to :actividad
  belongs_to :opcion_concepto

  def self.opciones(actividad_id)
    opciones = Array.new
    elecciones = Hash.new

    ActividadOpcion.where(["actividad_id=#{actividad_id}"]).order(:indice).each do |opcion|
      
      s = opcion.concepto != nil ? opcion.concepto : ""
      if ( opcion.cuotas != nil && opcion.cuotas > 0 )
        if ( opcion.cuotas == 1 )
          s = s + " a debitar contado de $U "
        else
          s = s + " a debitar en #{opcion.cuotas} cuotas de $U "
        end
        s = s + "#{opcion.importe}"
      end
      opciones.push( [s,opcion.id] )
      elecciones[opcion.id] = s
    end

    return { :opciones => opciones, :elecciones => elecciones }
  end
end
