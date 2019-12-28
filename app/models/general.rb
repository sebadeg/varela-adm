class General < ApplicationRecord

  def fecha_corta(fecha)
    return fecha != nil ? fecha.strftime('%d/%m/%Y') : ""
  end

  def fecha_larga(fecha)
    return fecha != nil ? "#{I18n.l(fecha, format: '%-d de %B de %Y')}" : ""
  end

end
