class Inscripcion2020 < ApplicationRecord
  belongs_to :alumno
  belongs_to :padre, :class_name => "Usuario"
  belongs_to :madre, :class_name => "Usuario"
  belongs_to :titular1, :class_name => "Usuario"
  belongs_to :titular2, :class_name => "Usuario"
  belongs_to :grado
  belongs_to :proximo_grado
  belongs_to :formulario2020
  belongs_to :convenio2020
  belongs_to :afinidad2020
  belongs_to :matricula2020
  belongs_to :hermanos2020
  belongs_to :cuota2020

  scope :inscripcion, -> { where("NOT reinscripcion") }
  scope :reinscripcion, -> { where("reinscripcion") }



def CalcularPrecio()

    cuotas = Array.new
    proximo_grado = ProximoGrado.find(proximo_grado_id) rescue nil
    if proximo_grado == nil
      return cuotas
    end
    importe_total = proximo_grado.precio

    # descuentos = Array.new
    # descuentos.push(convenio_id)
    # descuentos.push(adicional_id)
    # descuentos.push(hermanos_id)

    # p "------------------------------"
    # p "------------------------------"
    # p "------------------------------"
    # p importe_total
    # p descuentos


    # descuentos.each do |inscripcion_opcion_id|
    #   inscripcion_opcion = InscripcionOpcion.find(inscripcion_opcion_id) rescue nil
    #   if inscripcion_opcion != nil 
    #     if inscripcion_opcion.valor == nil
    #       importe_total = 0
    #       InscripcionOpcionCuota.where("inscripcion_opcion_id=#{inscripcion_opcion.id}").order(:fecha).each do |cuota|
    #         importe_total = importe_total + cuota.cantidad*cuota.importe
    #       end
    #     else
    #       importe_total = importe_total * ( 100.0 - inscripcion_opcion.valor ) / 100.0
    #     end
    #   end
    # end

    # p importe_total
    # p "------------------------------"
    # p "------------------------------"
    # p "------------------------------"

    #   inscripcion_opcion_cuotas = InscripcionOpcion.find(cuotas_id) rescue nil 
    #   if inscripcion_opcion_cuotas != nil
    #     InscripcionOpcionCuota.where("inscripcion_opcion_id=#{inscripcion_opcion_cuotas.id}").order(:fecha).each do |cuota|
    #      cuotas.push([cuota.cantidad,(importe_total*cuota.importe+0.5).to_i,cuota.fecha + 9.days])
    #    end

    cuotas.push([12,20000,DateTime.now])
    return cuotas
  end



  def self.numero_a_letras(n, uno)
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

  def self.cedula_tos(cedula)
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

  def cuotas_a_letras(cuotas)
    if cuotas.count == 1
      if cuotas[0][0] == 1        
        return "<b>1</b> cuota de $U <b>#{cuotas[0][1]}</b>, venciendo el día #{I18n.l(cuotas[0][2], format: '<b>%-d</b> de <b>%B</b> de <b>%Y</b>')}"
      else
        return "<b>#{cuotas[0][0]}</b> cuotas mensuales, iguales y consecutivas de $U <b>#{cuotas[0][1]}</b> cada una, venciendo la primera el día #{I18n.l(cuotas[0][2], format: '<b>%-d</b> de <b>%B</b> de <b>%Y</b>')}"
      end
    else
      mensaje = ""
      cuota = 0
      cuotas.each do |c|
        if mensaje != ""
          mensaje = mensaje + ", "
        end
        if c[0] == 1
          mensaje = mensaje + "la #{Inscripcion.numero_cuota_letras(cuota+1)} de $U <b>#{c[1]}</b> venciendo el día #{I18n.l(c[2], format: '<b>%-d</b> de <b>%B</b> de <b>%Y</b>')}"
        else
          mensaje = mensaje + "de la #{Inscripcion.numero_cuota_letras(cuota+1)} a la #{Inscripcion.numero_cuota_letras(cuota+c[0])} de $U <b>#{c[1]}</b> venciendo el día #{I18n.l(c[2], format: '<b>%-d</b> de <b>%B</b> de <b>%Y</b>')} y cada mes subsiguiente"
        end
        cuota = cuota + c[0]
      end
      return "<b>#{cuota}</b> cuotas, a saber: " + mensaje
    end
  end



  def vale(file_path)

    alumno = Alumno.find(alumno_id) rescue nil
    padre = Usuario.find(padre_id) rescue nil
    madre = Usuario.find(madre_id) rescue nil
    titular1 = Usuario.find(titular1_id) rescue nil
    titular2 = Usuario.find(titular2_id) rescue nil

    #cuotas = CalcularPrecio()

    cuotas = Array.new
    proximo_grado = ProximoGrado.find(proximo_grado_id) rescue nil
    if proximo_grado == nil
      return cuotas
    end
    total = proximo_grado.precio
    

    # total = 0
    # cuotas.each do |cuota|
    #   total = total + cuota[0]*cuota[1]
    # end

    total_letras = Inscripcion2020.numero_a_letras(total,true)

    cedula_alumno = Inscripcion2020.cedula_tos(alumno.cedula)
    nombre_alumno = ""
    if alumno != nil 
      nombre_alumno = alumno.nombre + " " + alumno.apellido
    end

    nombre_grado = ""
    proximo_grado = ProximoGrado.find(proximo_grado_id) rescue nil
    if proximo_grado != nil
      nombre_grado = proximo_grado.nombre
    end

    convenio_nombre = ""
    convenio = Convenio2020.find(convenio_id) rescue nil
    if convenio != nil
      convenio_nombre = "#{convenio.nombre} (#{convenio.descuento}%)"
    end

    afinidad_nombre = ""
    afinidad = Afinidad2020.find(afinidad_id) rescue nil
    if afinidad != nil
      afinidad_nombre = "#{afinidad.nombre} (#{afinidad.descuento}%)"
    end

    adicional_nombre = ""
    if adicional == nil
      adicional_nombre = "Adicional (#{adicional}%)"
    end
    
    congelado_nombre = ""
    if congelado == nil
      congelado_nombre = "Congelado (#{congelado}%)"
    end

    matricula_nombre = ""
    matricula = Matricula2020.find(matricula_id) rescue nil
    if matricula != nil
      matricula_nombre = matricula.nombre
    end

    hermanos_nombre = ""
    hermanos = Hermanos2020.find(hermanos_id) rescue nil
    if hermanos != nil
      hermanos_nombre = hermanos.nombre
    end

    idx=0
    nombreT = Array.new
    documentoT = Array.new
    domicilioT = Array.new
    emailT = Array.new
    celularT = Array.new

    if padre == nil
      padre = Usuario.new
    end
    if madre == nil
      madre = Usuario.new
    end

    if padre_titular != nil && padre_titular
      nombreT[idx] = "#{padre.nombre} #{padre.apellido}"
      documentoT[idx] = padre.cedula
      domicilioT[idx] = padre.direccion
      emailT[idx] = padre.email
      celularT[idx] = padre.celular
      idx = idx+1
    end

    if madre != nil && madre_titular != nil && madre_titular
      nombreT[idx] = "#{madre.nombre} #{madre.apellido}"
      documentoT[idx] = madre.cedula
      domicilioT[idx] = madre.direccion
      emailT[idx] = madre.email
      celularT[idx] = madre.celular
      idx = idx+1
    end

    if titular1 != nil
      nombreT[idx] = "#{titular1.nombre} #{titular1.apellido}"
      documentoT[idx] = titular1.cedula
      domicilioT[idx] = titular1.direccion
      emailT[idx] = titular1.email
      celularT[idx] = titular1.celular
      idx = idx+1
    end

    if titular2 != nil
      nombreT[idx] = "#{titular2.nombre} #{titular2.apellido}"
      documentoT[idx] = titular2.cedula
      domicilioT[idx] = titular2.direccion
      emailT[idx] = titular2.email
      celularT[idx] = titular2.celular
      idx = idx+1
    end

    if reinscripcion
      titulo = "<b>REINSCRIPCION</b>"
    else
      titulo = "<b>INSCRIPCION</b>"
    end

    texto_inscripcion =
      "#{titulo}<br>"+      
      "Fecha: #{fecha_tos(created_at)}<br>" +
      "Recibida por: #{recibida}<br>" +
      "<br>" +
      "<b>NIVEL</b><br>" +
      "Grado: #{nombre_grado}<br>" +
      "Descuento: #{convenio_nombre} + #{afinidad_nombre} + #{adicional_nombre} + #{congelado_nombre}<br>" +
      "Matrícula: #{matricula_nombre}<br>" +
      "Hermanos: #{hermanos_nombre}<br>" +
      "<br>"+
      "<b>ALUMNO</b><br>" +
      "Nombre: #{alumno.nombre} #{alumno.apellido}<br>" +
      "Documento de identidad: #{Inscripcion2020.cedula_tos(alumno.cedula)}<br>" +
      "Lugar de nacimiento: #{alumno.lugar_nacimiento}<br>" +
      "Fecha de nacimiento: #{fecha_tos(alumno.fecha_nacimiento)}<br>" +
      "Domicilio: #{alumno.direccion}<br>" + 
      "Teléfono/Celular: #{alumno.celular}<br>" + 
      "Mutualista: #{alumno.mutualista}<br>" + 
      "Emergencia: #{alumno.emergencia}<br>" + 
      "Procede de: #{alumno.procede}<br>"

      texto_padre =
      "<b>PADRE</b><br>" +
      "Nombre: #{padre.nombre} #{padre.apellido}<br>" +
      "Documento de identidad: #{Inscripcion2020.cedula_tos(padre.cedula)}<br>" +
      "Lugar de nacimiento: #{padre.lugar_nacimiento}<br>" +
      "Fecha de nacimiento: #{fecha_tos(padre.fecha_nacimiento)}<br>" +
      "Mail: #{padre.email}<br>" + 
      "Domicilio: #{padre.direccion}<br>" + 
      "Teléfono/Celular: #{padre.celular}<br>" + 
      "Profesión: #{padre.profesion}<br>" + 
      "Lugar de trabajo: #{padre.trabajo}<br>" + 
      "Teléfono de trabajo: #{padre.telefono_trabajo}<br>" 

      texto_madre =
      "<b>MADRE</b><br>" +
      "Nombre: #{madre.nombre} #{madre.apellido}<br>" +
      "Documento de identidad: #{Inscripcion2020.cedula_tos(madre.cedula)}<br>" +
      "Lugar de nacimiento: #{madre.lugar_nacimiento}<br>" +
      "Fecha de nacimiento: #{fecha_tos(madre.fecha_nacimiento)}<br>" +
      "Mail: #{madre.email}<br>" + 
      "Domicilio: #{madre.domicilio}<br>" + 
      "Teléfono/Celular: #{madre.celular}<br>" + 
      "Profesión: #{madre.profesion}<br>" + 
      "Lugar de trabajo: #{madre.trabajo}<br>" + 
      "Teléfono de trabajo: #{madre.telefono_trabajo}<br><br>"

    texto_nota = "<b>NOTA: Para la inscripción deberá presentar: fotocopia de la C.I. del/los Titular/es de la cuenta y si corresponde Libre de Deuda o recibo del último pago realizado en la Institución de donde proviene.<br><br>" +
           "LA AUTORIZACIÓN DEFINITIVA SERÁ DADA UNA VEZ REALIZADO EL CLEARING DE INFORMES<br><br>" +
           "El que suscribe ______________________________ declara que los datos aportados son ciertos y actuales y los informa a los efectos de la contratación de los servicios educativos que el Colegio Nacional José Pedro Varela provee. La actualización de los datos proveídos es responsabilidad de la parte.</b>"



    informacion = 
      "El alumno #{nombre_alumno} cuya cédula es #{alumno.cedula} ha comenzado el proceso de reinscripción para el año lectivo #{anio} en " + 
      "#{nombre_grado} del Colegio Nacional José Pedro Varela."

    cabezal = 
      "$U <b>#{total}</b>" + 
      "<br><br>" +
      "Lugar y fecha de emisión: <b>Montevideo, #{I18n.l(DateTime.now, format: '%-d de %B de %Y')}</b>";

    if cuotas.count==1 && cuotas[0][0] == 1
      texto = "<b>VALE</b>"
    else
      texto = "<b>VALE AMORTIZABLE</b>"
    end

    texto = texto + " por la cantidad de pesos uruguayos <b>#{total_letras}</b> que debo (debemos) y pagaré (pagaremos) en forma " +
      "indivisible y solidaria a la Sociedad Uruguaya de Enseñanza, Colegio Nacional José Pedro Varela - o a su orden, en la misma moneda, en " +
      "#{cuotas_a_letras(cuotas)}, en el domicilio del acreedor sito en la calle Colonia 1637 de la ciudad de Montevideo, o donde indique el acreedor." +
      "<br><br>" + 
      "La falta de pago de dos o más cuotas a su vencimiento producirá la mora de pleno derecho sin necesidad de interpelación de clase alguna, " +
      "devengándose por esa sola circunstancias, intereses moratorios del 40% (cuarenta por ciento) tasa efectiva anual (aprobada por BCU) y hará " +
      "exigible la totalidad del monto adeudado más los intereses moratorios generados a partir del incumplimiento y hasta su efectiva y total " + 
      "cancelación." +
      "<br><br>" + 
      "En caso de incumplimiento total o parcial del presente título, el acreedor a su elección, podrá demandar la ejecución de este título ante " +
      "los Jueces del lugar de residencia del deudor o ante los del lugar del cumplimiento de la obligación." +
      "<br><br>" + 
      "Para todos los efectos judiciales y/o extrajudiciales a que pudiera dar lugar éste documento, el deudor constituye como domicilio especial el " +
      "abajo denunciado." +
      "<br><br><br>" + 
      "NOMBRE COMPLETO: #{nombreT[0]}<br><br>" +
      "DOCUMENTO DE IDENTIDAD: #{Inscripcion.cedula_tos(documentoT[0])}<br><br>" +
      "DOMICILIO: #{domicilioT[0]}<br><br>" +
      "MAIL: #{emailT[0]}<br><br>" +
      "TEL/CEL: #{celularT[0]}<br><br>" +
      "FIRMA:<br><br>" +
      "Aclaración:<br><br>" +
      "<br><br>" +
      "NOMBRE COMPLETO: #{nombreT[1]}<br><br>" +
      "DOCUMENTO DE IDENTIDAD: #{Inscripcion.cedula_tos(documentoT[1])}<br><br>" +
      "DOMICILIO: #{domicilioT[1]}<br><br>" +
      "MAIL: #{emailT[1]}<br><br>" +
      "TEL/CEL: #{celularT[1]}<br><br>" +
      "FIRMA:<br><br>" +
      "Aclaración:<br><br>";

    text_file = Tempfile.new("text.pdf")
    text_file_path = text_file.path

    reinsc = reinscripcion

    Prawn::Document.generate(text_file_path) do

      if reinsc
        font "Helvetica", :size => 12

        dash 5, space: 0, phase:0
        stroke_color "0000FF"
        stroke_rectangle [0, 720], 540, 280
        stroke_color "FF0000"
        stroke_rectangle [2, 718], 536, 276

        image Rails.root.join("data", "logo.png"), at: [203,700], scale: 0.5

        bounding_box([20, 550], :width => 500, :height => 60) do
          text titulo, align: :center, inline_format: true
        end

        bounding_box([60, 530], :width => 420, :height => 60) do
          text informacion, align: :center, inline_format: true
        end

        bounding_box([0, 410], :width => 500, :height => 60) do
          text "Recibido por:", align: :left, inline_format: true
        end
        bounding_box([0, 390], :width => 500, :height => 60) do
          text "Fecha:", align: :left, inline_format: true
        end

        stroke_color "000000"
        dash 5, space: 5, phase:0
        stroke_horizontal_line -40, 580, at: 360

        dash 5, space: 0, phase:0
        stroke_color "0000FF"
        stroke_rectangle [0, 330], 540, 280
        stroke_color "FF0000"
        stroke_rectangle [2, 328], 536, 276

        image Rails.root.join("data", "logo.png"), at: [203,310], scale: 0.5

        bounding_box([20, 160], :width => 500, :height => 60) do
          text titulo, align: :center, inline_format: true
        end

        bounding_box([60, 140], :width => 420, :height => 60) do
          text informacion, align: :center, inline_format: true
        end

        bounding_box([0, 20], :width => 500, :height => 60) do
          text "Recibido por:", align: :left, inline_format: true
        end
        bounding_box([0, 0], :width => 500, :height => 60) do
          text "Fecha:", align: :left, inline_format: true
        end

        start_new_page
      end

      if !reinsc
        font "Helvetica", :size => 10
        
        dash 5, space: 0, phase:0
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
      end

      font "Helvetica", :size => 10

      dash 5, space: 0, phase:0
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
