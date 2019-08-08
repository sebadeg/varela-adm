class Convenio < ApplicationRecord
  has_many :alumnos, through: :inscripcion_alumno
  has_many :inscripcion


#<b>1</b> cuota de $U <b>#{importe_cuota}</b>, venciendo el día <b>#{dia}</b> de <b>#{mesS}</b> del <b>#{anio}</b>

#<b>#{cuotas}</b> cuotas mensuales, iguales y consecutivas de $U <b>#{importe_cuota}</b> cada una, venciendo la primera el día <b>#{dia}</b> de <b>#{mesS}</b> del <b>#{anio}</b>

#<b>#{cuotas}</b> cuotas mensuales y consecutivas, a saber: la primera de $U <b>43523</b> con vencimiento <b>10</b> de <b>enero</b> de <b>2019</b>, de la segunda a la duodécima con vencimientos el <b>10</b> de cada mes subsiguiente de $U <b>8531</b> cada una

#<b>#{cuotas}</b> cuotas mensuales y consecutivas, a saber: de la primera a la quinta de $U <b>8280</b> con vencimiento el <b>10</b> de <b>abril</b> de <b>2019</b> y cada mes subsiguiente y de la sexta a la décima con vencimientos el <b>10</b> y cada mes subsiguiente de $U <b>12420</b> cada una


  def self.numero_cuota_letras(cuota)
  	s = ""
    case cuota
    when 1
      s = "primera"
    when 2
      s = "segunda"
    when 3
      s = "tercera"
    when 4
      s = "cuarta"
    when 5
      s = "quinta"
    when 6
      s = "sexta"
    when 7
      s = "septima"
    when 8
      s = "octava"
    when 9
      s = "novena"
    when 10
      s = "décima"
    when 11
      s = "undécima"
    when 12
      s = "duodécima"
    when 13
      s = "decimotercera"
    when 14
      s = "decimocuarta"
    when 15
      s = "decimoquinta"
    when 16
      s = "decimosexta"
    when 17
      s = "decimoseptima"
    when 18
      s = "decimoctava"
    when 19
      s = "decimonovena"
    when 20
      s = "vigésima"
    when 21
      s = "vigesimoprimera"
    when 22
      s = "vigesimosegunda"
    when 23
      s = "vigesimotercera"
    when 24
      s = "vigesimocuarta"
    end
    return s
  end
end
