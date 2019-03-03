class ActividadOpcion < ApplicationRecord
  belongs_to :actividad

  def self.opciones(actividad_id)
    opciones = Array.new
    elecciones = Hash.new

    ActividadOpcion.where(["actividad_id=#{self.actividad_id}"]).order(:id).each do |opcion|
      
      s = opcion.concepto
      if ( opcion.cuotas > 0 )
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
