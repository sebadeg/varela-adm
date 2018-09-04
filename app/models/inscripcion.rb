class Inscripcion < ApplicationRecord
  belongs_to :convenio
  belongs_to :proximo_grado

  validates :nombre, presence: true
  validates :cedula, presence: true
  validates :cedula, numericality: { only_integer: true, greater_than:0, less_than: 100000000 }
  validates :lugar_nacimiento, presence: true
  validates :fecha_nacimiento, presence: true
  validates :domicilio, presence: true
  validates :celular, presence: true
  validates :mutualista, presence: true
  validates :emergencia, presence: true
  validates :procede, presence: true

  validates :proximo_grado_id, presence: true
  validates :convenio_id, presence: true
  validates :matricula, presence: true
  validates :hermanos, presence: true
  validates :cuotas, presence: true
  validates :cuotas, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }

  validates :documento1, numericality: { only_integer: true, allow_nil: true, greater_than:0, less_than: 100000000 }
  validates :documento2, numericality: { only_integer: true, allow_nil: true, greater_than:0, less_than: 100000000 }
  validates :cedula_padre, numericality: { only_integer: true, allow_nil: true, greater_than:0, less_than: 100000000 }
  validates :cedula_madre, numericality: { only_integer: true, allow_nil: true, greater_than:0, less_than: 100000000 }

  validate :cedula_digit
  validate :cedula_padre_digit
  validate :cedula_madre_digit
  validate :documento1_digit
  validate :documento1_digit
  validate :documento2_digit


  def calc_cedula(ced)
    if ( ced == nil )      
      return true
    end
    suma = 0
    arr = [4,3,6,7,8,9,2]
    digit = ced%10 
    c = ced/10
    (0..6).each do |i|
       r = c%10
       c = c/10
       suma = (suma + r*arr[i]) % 10
    end
    if digit != ((10-(suma%10))%10)
      return false
    end
    return true
  end

  def cedula_digit
    if (!calc_cedula(cedula))
      errors.add(:cedula, "con dígito verificador mal")
    end
  end

  def cedula_padre_digit
    if (!calc_cedula(cedula_padre))
      errors.add(:cedula_padre, "con dígito verificador mal")
    end
  end

  def cedula_madre_digit
    if (!calc_cedula(cedula_madre))
      errors.add(:cedula_madre, "con dígito verificador mal")
    end
  end

  def documento1_digit
    if (!calc_cedula(documento1))
      errors.add(:documento1, "con dígito verificador mal")
    end
  end

  def documento2_digit
    if (!calc_cedula(documento2))
      errors.add(:documento2, "con dígito verificador mal")
    end
  end


  def find(arr,v)
    arr.each do |a|
      if a[1]==v
        return a[0]
      end
    end
    return ""
  end


  def numero_a_letras(n, uno)
    s = ""
    if (n/1000>0)
      s = numero_a_letras((n/1000).to_i,false) + " mil ";
    end
    n = (n%1000).to_i;
    case (n/100).to_i
    when 1
      if n%100 != 0
        s = s + "ciento"
      else
        s = s + "cien"
      end
    when 2
      s = s + "doscientos"
    when 3
      s = s + "trescientos"
    when 4
      s = s + "cuatrocientos"
    when 5
      s = s + "quinientos"
    when 6
      s = s + "siescientos"
    when 7
      s = s + "setecientos"
    when 8
      s = s + "ochocientos"
    when 9
      s = s + "novecientos"
    end
    n = (n%100).to_i
    if n > 0
      s = s + " "
    end
    case (n/10).to_i
    when 3
      s = s + "treinta"
    when 4
      s = s + "cuarenta"
    when 5
      s = s + "cincuenta"
    when 6
      s = s + "sesenta"
    when 7
      s = s + "setenta"
    when 8
      s = s + "ochenta"
    when 9
      s = s + "noventa"
    end
    if ( n >= 30 )
      if (n%10).to_i != 0
        s = s + " y "
      end
      n = (n%10).to_i
    end
    case n          
    when 1
      if ( uno )
        s = s + "uno"
      else
        s = s + "un"
      end
    when 2
      s = s + "dos"
    when 3
      s = s + "tres"
    when 4
      s = s + "cuatro"
    when 5
      s = s + "cinco"
    when 6
      s = s + "seis"
    when 7
      s = s + "siete"
    when 8
      s = s + "ocho"
    when 9
      s = s + "nueve"
    when 10
      s = s + "diez"
    when 11
      s = s + "once"
    when 12
      s = s + "doce"
    when 13
      s = s + "trece"
    when 14
      s = s + "catorce"
    when 15
      s = s + "quince"
    when 16
      s = s + "dieciseis"
    when 17
      s = s + "diecisiete"
    when 18
      s = s + "dieciocho"
    when 19
      s = s + "diecinueve"
    when 20
      s = s + "veinte"
    when 21
      if uno
        s = s + "veintiuno"
      else
        s = s + "veintiun"
      end
    when 22
      s = s + "veintidos"
    when 23
      s = s + "veintitres"
    when 24
      s = s + "veinticuatro"
    when 25
      s = s + "veinticinco"
    when 26
      s = s + "veintiseis"
    when 27
      s = s + "veintisiete"
    when 28
      s = s + "veintiocho"
    when 29
      s = s + "veintinueve"
    end
    return s
  end

  def cedula_tos(cedula)
    if ( cedula == nil )
      return ""
    end
    return (cedula/10).to_s + "-" + (cedula%10).to_s
  end

  def fecha_tos(fecha)
    if ( fecha == nil )
      return ""
    end
    return I18n.l(fecha, format: '%-d de %B de %Y')
  end

  def formulario(file_path)

    inscripcion = Inscripcion.find(id)

    convenio = Convenio.find(inscripcion.convenio_id) rescue nil
    proximo_grado = ProximoGrado.find(inscripcion.proximo_grado_id) rescue nil

    convenio_nombre = (convenio != nil ? "#{convenio.nombre} - #{convenio.valor} %" : "")
    proximo_grado_nombre = (proximo_grado != nil ? "#{proximo_grado.nombre} - $U #{proximo_grado.precio}" : "")
    matriculaS = find([["Contado",5],["Exhonerada",6]],inscripcion.matricula)
    hermanosS = find([["Sin hermanos",0],["1 hermano - 5%",1],["2 hermanos - 10%",2]],inscripcion.hermanos)

    idx=0
    nombreT = Array.new
    documentoT = Array.new
    domicilioT = Array.new
    emailT = Array.new
    celularT = Array.new

    if (inscripcion.titular_padre)
      nombreT[idx] = inscripcion.nombre_padre
      documentoT[idx] = inscripcion.cedula_padre
      domicilioT[idx] = inscripcion.domicilio_padre
      emailT[idx] = inscripcion.email_padre
      celularT[idx] = inscripcion.celular_padre
      idx = idx+1
    end

    if (inscripcion.titular_madre)
      nombreT[idx] = inscripcion.nombre_madre
      documentoT[idx] = inscripcion.cedula_madre
      domicilioT[idx] = inscripcion.domicilio_madre
      emailT[idx] = inscripcion.email_madre
      celularT[idx] = inscripcion.celular_madre
      idx = idx+1
    end

    if (inscripcion.nombre1 != nil && inscripcion.nombre1 != "")
      nombreT[idx] = inscripcion.nombre1
      documentoT[idx] = inscripcion.documento1
      domicilioT[idx] = inscripcion.domicilio1
      emailT[idx] = inscripcion.email1
      celularT[idx] = inscripcion.celular1
      idx = idx+1
    end

    if (inscripcion.nombre2 != nil && inscripcion.nombre2 != "")
      nombreT[idx] = inscripcion.nombre2
      documentoT[idx] = inscripcion.documento2
      domicilioT[idx] = inscripcion.domicilio2
      emailT[idx] = inscripcion.email2
      celularT[idx] = inscripcion.celular2
      idx = idx+1
    end


    texto_inscripcion =
      "<b>INSCRIPCION</b><br>"+      
      "<br>"+
      "Fecha: #{fecha_tos(inscripcion.created_at)}<br>" +
      "Recibida por: #{inscripcion.recibida}<br>" +
      "<br>" +
      "<b>NIVEL</b><br>" +
      "<br>" +
      "Grado: #{proximo_grado_nombre}<br>" +
      "Convenio: #{convenio_nombre}<br>" +
      "Matrícula: #{matriculaS}<br>" +
      "Hermanos: #{hermanosS}<br>" +
      "Cuotas: #{inscripcion.cuotas}<br>" + 
      "<br>"+
      "<b>ALUMNO</b><br>" +
      "<br>"+
      "Nombre: #{inscripcion.nombre}<br>" +
      "Documento de identidad: #{cedula_tos(inscripcion.cedula)}<br>" +
      "Lugar de nacimiento: #{inscripcion.lugar_nacimiento}<br>" +
      "Fecha de nacimiento: #{fecha_tos(inscripcion.fecha_nacimiento)}<br>" +
      "Domicilio: #{inscripcion.domicilio}<br>" + 
      "Teléfono/Celular: #{inscripcion.celular}<br>" + 
      "Mutualista: #{inscripcion.mutualista}<br>" + 
      "Emergencia: #{inscripcion.emergencia}<br>" + 
      "Procede de: #{inscripcion.procede}<br>"

      texto_padre =
      "<b>PADRE</b><br>" +
      "<br>" +
      "Nombre: #{inscripcion.nombre_padre}<br>" +
      "Documento de identidad: #{cedula_tos(inscripcion.cedula_padre)}<br>" +
      "Lugar de nacimiento: #{inscripcion.lugar_nacimiento_padre}<br>" +
      "Fecha de nacimiento: #{fecha_tos(inscripcion.fecha_nacimiento_padre)}<br>" +
      "Mail: #{inscripcion.email_padre}<br>" + 
      "Domicilio: #{inscripcion.domicilio_padre}<br>" + 
      "Teléfono/Celular: #{inscripcion.celular_padre}<br>" + 
      "Profesión: #{inscripcion.profesion_padre}<br>" + 
      "Lugar de trabajo: #{inscripcion.trabajo_padre}<br>" + 
      "Teléfono de trabajo: #{inscripcion.telefono_trabajo_padre}<br>" 

      texto_madre =
      "<b>MADRE</b><br>" +
      "<br>" +
      "Nombre: #{inscripcion.nombre_madre}<br>" +
      "Documento de identidad: #{cedula_tos(inscripcion.cedula_madre)}<br>" +
      "Lugar de nacimiento: #{inscripcion.lugar_nacimiento_madre}<br>" +
      "Fecha de nacimiento: #{fecha_tos(inscripcion.fecha_nacimiento_madre)}<br>" +
      "Mail: #{inscripcion.email_madre}<br>" + 
      "Domicilio: #{inscripcion.domicilio_madre}<br>" + 
      "Teléfono/Celular: #{inscripcion.celular_madre}<br>" + 
      "Profesión: #{inscripcion.profesion_madre}<br>" + 
      "Lugar de trabajo: #{inscripcion.trabajo_madre}<br>" + 
      "Teléfono de trabajo: #{inscripcion.telefono_trabajo_madre}<br><br>"

    texto_nota = "<b>NOTA: Para la inscripción deberá presentar: fotocopia de la C.I. del/los Titular/es de la cuenta y si corresponde Libre de Deuda o recibo del último pago realizado en la Institución de donde proviene.<br><br>" +
           "LA AUTORIZACIÓN DEFINITIVA SERÁ DADA UNA VEZ REALIZADO EL CLEARING DE INFORMES<br><br>" +
           "El que suscribe ______________________________ declara que los datos aportados son ciertos y actuales y los informa a los efectos de la contratación de los servicios educativos que el Colegio Nacional José Pedro Varela provee. La actualización de los datos proveídos es responsabilidad de la parte.</b>"





    importe_total = proximo_grado.precio 

    importe_total = importe_total * ( 100 - convenio.valor ) / 100
    if  (inscripcion.hermanos == 1 )
      importe_total = importe_total * 0.95
    elsif  (inscripcion.hermanos == 2 )
      importe_total = importe_total * 0.9
    end
    if inscripcion.afinidad
      importe_total = importe_total * 0.95
    end
    importe_total = importe_total * (100-inscripcion.formulario/100.0)

    importe_total = (importe_total + 0.5).to_i

    cuotas = inscripcion.cuotas
    importe_cuota = (importe_total/cuotas+0.5).to_i
    importe_total = ( importe_cuota * cuotas).to_i

    importe_letras = numero_a_letras(importe_total,true)

    if cuotas==12
      mes = 1
    elsif cuotas==11
      mes = 2
    elsif cuotas==10
      mes = 3
    end

    desde = DateTime.new(2019,mes,10)
    anio = 2019

    mes = I18n.l(desde, format: '%B')

    hoy = DateTime.now
    hoyS = "#{hoy.day} de #{hoy.month} de #{hoy.year}"

    nombre = inscripcion.nombre
    cedula = cedula_tos(inscripcion.cedula)
    
    cabezal = 
      "$U <b>#{importe_total}</b>" + 
      "<br><br>" +
      "Lugar y fecha de emisión: <b>Montevideo, #{I18n.l(DateTime.now, format: '%-d de %B de %Y')}</b>";
    texto =
      "<b>VALE AMORTIZABLE</b> por la cantidad de pesos uruguayos <b>#{importe_letras}</b> que debo (debemos) y pagaré (pagaremos) en forma indivisible y solidaria a la Sociedad Uruguaya de Enseñanza, Colegio Nacional José Pedro Varela - o a su orden, en la misma moneda, en <b>#{cuotas}</b> cuotas mensuales, iguales y consecutivas de $U <b>#{importe_cuota}</b> cada una, venciendo la primera el día 10 de <b>#{mes}</b> del <b>#{anio}</b>, en el domicilio del acreedor sito en la calle Colonia 1637 de la ciudad de Montevideo, o donde indique el acreedor." +
      "<br><br>" + 
      "La falta de pago de dos o más cuotas a su vencimiento producirá la mora de pleno derecho sin necesidad de interpelación de clase alguna, devengándose por esa sola circunstancias, intereses moratorios del 40% (cuarenta por ciento) tasa efectiva anual (aprobada por BCU) y hará exigible la totalidad del monto adeudado más los intereses moratorios generados a partir del incumplimiento y hasta su efectiva y total cancelación." +
      "<br><br>" + 
      "En caso de incumplimiento total o parcial del presente título, el acreedor a su elección, podrá demandar la ejecución de este título ante los Jueces del lugar de residencia del deudor o ante los del lugar del cumplimiento de la obligación." +
      "<br><br>" + 
      "Para todos los efectos judiciales y/o extrajudiciales a que pudiera dar lugar éste documento, el deudor constituye como domicilio especial el abajo denunciado." +
      "<br><br><br>" + 
      "NOMBRE COMPLETO: #{nombreT[0]}<br><br>" +
      "DOCUMENTO DE IDENTIDAD: #{cedula_tos(documentoT[0])}<br><br>" +
      "DOMICILIO: #{domicilioT[0]}<br><br>" +
      "MAIL: #{emailT[0]}<br><br>" +
      "TEL/CEL: #{celularT[0]}<br><br>" +
      "FIRMA:<br><br>" +
      "Aclaración:<br><br>" +
      "<br><br>" +
      "NOMBRE COMPLETO: #{nombreT[1]}<br><br>" +
      "DOCUMENTO DE IDENTIDAD: #{cedula_tos(documentoT[1])}<br><br>" +
      "DOMICILIO: #{domicilioT[1]}<br><br>" +
      "MAIL: #{emailT[1]}<br><br>" +
      "TEL/CEL: #{celularT[1]}<br><br>" +
      "FIRMA:<br><br>" +
      "Aclaración:<br><br>";


    text_file = Tempfile.new("text.pdf")
    text_file_path = text_file.path

    Prawn::Document.generate(text_file_path) do
      font "Helvetica", :size => 10
      
      stroke_color "0000FF"
      stroke_rectangle [0, 720], 540, 720   
      stroke_color "FF0000"
      stroke_rectangle [2, 718], 536, 716

      image Rails.root.join("data", "logo.png"), at: [203,700], scale: 0.5

      bounding_box([20, 570], :width => 500, :height => 300) do
        text texto_inscripcion, align: :left, inline_format: true
      end

      bounding_box([20, 280], :width => 250, :height => 150) do
        text texto_padre, align: :left, inline_format: true
      end

      bounding_box([270, 280], :width => 250, :height => 150) do
        text texto_madre, align: :left, inline_format: true
      end

      bounding_box([20, 120], :width => 500, :height => 120) do
        text texto_nota, align: :justify, inline_format: true
      end

    start_new_page

      font "Helvetica", :size => 10

      stroke_color "0000FF"
      stroke_rectangle [0, 720], 540, 720   
      stroke_color "FF0000"
      stroke_rectangle [2, 718], 536, 716

      bounding_box([20, 700], :width => 500, :height => 60) do
        text cabezal, align: :right, inline_format: true
      end
      bounding_box([20, 640], :width => 500, :height => 600) do
        text texto, align: :justify, inline_format: true
      end

    end

    pdf = CombinePDF.new
    pdf << CombinePDF.load(text_file_path)
    pdf.save file_path

    text_file.unlink

  end

end
