class Factura < ApplicationRecord
  has_many :linea_factura, :dependent => :delete_all
  accepts_nested_attributes_for :linea_factura, allow_destroy: true



    require 'chunky_png'
    require 'barby'
    require 'barby/barcode/code_128'
    #require 'barby/barcode/code_39'
    require 'barby/outputter/png_outputter'

    def digito(s)
      suma = 0
      (0..(s.length-1)).each do |i|
        suma = suma + s[i,1].to_i
      end
      return 9-(suma%10)
    end


    def imprimir(file_path,cuenta_id,factura)

      dolar = factura.dolar

      s = factura.fecha.strftime('%Y%m') + 
        factura.id.to_s.rjust(6,'0') +
        cuenta_id.to_s.rjust(5,'0') + 
        (factura.total * 100).to_i.to_s.rjust(8,'0') +
        factura.fecha_vencimiento.strftime('%Y%m%d')
      
      dig = digito(s).to_s

      codigo_barras = '*JP' + s + "00" + dig + '*'

      usuario = Usuario.where("id IN (SELECT usuario_id FROM titular_cuentas WHERE cuenta_id=#{cuenta_id})").first!
      lineas = LineaFactura.where( "factura_id=#{factura.id}" ).order(:indice)
      cuenta = Cuenta.find(cuenta_id)

   	  text_file = Tempfile.new("text.pdf")
 	    text_file_path = text_file.path
      template_file = Rails.root.join("data", 'factura.pdf')

      i = 606 
      f = 268

      renglon = (i-f)*1.0/15

      barcode = Barby::Code128B.new(codigo_barras)
      #barcode = Barby::Code39.new(codigo_barras, true)

 	    barcode_file = Tempfile.new("barcode.png")
        File.open(barcode_file.path, 'wb') do |f|
		    f.write barcode.to_png(:height => 15, :margin => 0)
	    end

      Prawn::Document.generate(text_file_path) do

        text_box "Titular", :at => [190, 710]
        text_box "Cuenta", :at => [190, 710-renglon]
        text_box "Factura", :at => [190, 710-2*renglon]
        text_box "Vencimiento", :at => [190, 710-3*renglon]

        bounding_box([280, 710], :width => 240, :height => renglon) do
          text_box cuenta.nombre, align: :left
          transparent(0) { stroke_bounds }
        end
        text_box cuenta_id.to_s, :at => [280, 710-renglon]
        text_box factura.id.to_s, :at => [280, 710-2*renglon]
        text_box factura.fecha_vencimiento.strftime('%d/%m/%Y'), :at => [280, 710-3*renglon]

        text_box "Alumno", :at => [10, 606]
        text_box "Grado", :at => [190, 606]
        text_box "Concepto", :at => [280, 606]
        text_box "Importe", :at => [450, 606]

        # Generate whatever you want here.
        indice = 1
        lineas.each do |linea|

          bounding_box([10, i-indice*renglon], :width => 160, :height => renglon) do
            text_box linea.nombre_alumno, align: :left
            transparent(0) { stroke_bounds }
          end

          text_box "", :at => [190, i-indice*renglon]

          #text_box linea.descripcion, :at => [280, i-indice*renglon]
          bounding_box([280, i-indice*renglon], :width => 160, :height => renglon) do
            text_box linea.descripcion, align: :left
            transparent(0) { stroke_bounds }
          end



          bounding_box([450, i-indice*renglon], :width => 70, :height => renglon) do
           if dolar == nil
              text_box linea.importe.to_s, align: :right
            else
              text_box "US$", align: :left
              text_box (linea.importe/dolar).round(1).to_s, align: :right
            end
           transparent(0) { stroke_bounds }
          end

          indice = indice+1          
        end

        text_box "Total", :at => [200, 145]
        bounding_box([320, 145], :width => 200, :height => renglon) do
          if dolar == nil
            text_box factura.total.to_s, align: :right
          else
            text_box "US$", align: :left
            text_box (factura.total/dolar).round(1).to_s, align: :right
          end
          transparent(0) { stroke_bounds }
        end

        image barcode_file.path, at: [20, 25]

        text_box codigo_barras, :at => [170, 8], size:8

        text_box (factura.fecha - 1.days).strftime('%d/%m/%Y'), :at => [325, 106], size:8

        delta=73

        text_box "Emisión", :at => [20, 41], size:8
        text_box "Vencimiento", :at => [20+delta, 41], size:8
        text_box "Documento", :at => [20+2*delta, 41], size:8
        text_box "Cuenta", :at => [20+3*delta, 41], size:8
        text_box "Factura", :at => [20+4*delta, 41], size:8
        text_box "Moneda", :at => [20+5*delta, 41], size:8
        text_box "Importe", :at => [20+6*delta, 41], size:8

        text_box I18n.l(factura.fecha, format: '%B'), :at => [20, 33], size:8
        text_box factura.fecha_vencimiento.strftime('%d/%m/%Y'), :at => [20+delta, 33], size:8
        text_box "Factura", :at => [20+2*delta, 33], size:8
        text_box cuenta_id.to_s, :at => [20+3*delta, 33], size:8
        text_box factura.id.to_s, :at => [20+4*delta, 33], size:8
        if ( dolar == nil )
          text_box "UYU", :at => [20+5*delta, 33], size:8
        else
          text_box "USD", :at => [20+5*delta, 33], size:8
        end
        text_box factura.total.to_s , :at => [20+6*delta, 33], size:8
      end

      pdf = CombinePDF.new
      pdf << CombinePDF.load(template_file) # one way to combine, very fast.
      pdf.pages.each {|page| page <<  CombinePDF.load(text_file_path).pages[0]}
      pdf.save file_path

	    text_file.unlink
	    barcode_file.unlink

    end

  def self.verificar_fecha_facturacion(fecha)
    config = Config.find(1)

    return fecha > config.fecha_descarga
  end

  def self.generar_recargos()

    config = Config.find(1)

    fecha_factura = config.fecha_facturacion - 1.month
    fecha_factura_anterior = fecha_factura - 1.month
    fecha_vencimiento_factura_anterior = fecha_factura_anterior + 9.days

    rubro = Rubro.find_by(nombre: "Intereses por atraso")
    p "********************"
    p rubro.id
    p "********************"

    saldos = Hash.new
    corrientes = Hash.new
    Movimiento.where(["fecha < ? AND NOT cuenta_id IN (SELECT cuenta_id FROM recargos WHERE fecha_comienzo<=? AND (fecha_fin IS NULL OR fecha_fin>?))",fecha_factura_anterior,fecha_factura,fecha_factura]).group(:cuenta_id).order(:cuenta_id).select("cuenta_id, sum(debe-haber) as saldo").each do |saldo|
      saldos[saldo.cuenta_id] = saldo.saldo
    end
    Movimiento.where(["fecha = ? AND debe <> 0 AND haber = 0 AND NOT cuenta_id IN (SELECT cuenta_id FROM recargos WHERE fecha_comienzo<=? AND (fecha_fin IS NULL OR fecha_fin>?))",fecha_factura_anterior,fecha_factura,fecha_factura]).group(:cuenta_id).order(:cuenta_id).select("cuenta_id, sum(debe) as debe").each do |corriente|
      if !saldos.has_key?(corriente.cuenta_id)
        saldos[corriente.cuenta_id] = 0
      end
      corrientes[corriente.cuenta_id] = corriente.debe
    end
    i = 0
    saldos.keys.sort.each do |cuenta_id|

      if !corrientes.has_key?(cuenta_id)
        corrientes[cuenta_id] = 0
      end

      tea = 1.38 ** (1.0/365.0)
      total_recargo = 0

      saldo = saldos[cuenta_id]
      corriente = corrientes[cuenta_id]
      if saldo < 0
        corriente = corriente + saldo
      end

      Movimiento.where(["cuenta_id = ? AND fecha >= ? AND fecha < ? AND haber>0",cuenta_id,fecha_factura_anterior,fecha_factura]).order(:fecha).select(:fecha,:haber).each do |pago|

        fecha = pago.fecha
        importe = pago.haber
        recargo = 0
        if saldo > 0
          if importe > saldo
            importe = importe - saldo
            if (pago.fecha - fecha_factura_anterior).to_i > 0
              recargo = (tea**((pago.fecha - fecha_factura_anterior).to_i)-1)*saldo
            end
            saldo = 0
          else
            saldo = saldo - importe
            if (pago.fecha - fecha_factura_anterior).to_i > 0
              recargo = (tea**((pago.fecha - fecha_factura_anterior).to_i)-1)*importe
            end
            importe = 0
          end
        end

        if corriente > 0
          if importe > corriente
            importe = importe - corriente
            if (pago.fecha - fecha_vencimiento_factura_anterior).to_i > 0
              recargo = recargo + (tea**((pago.fecha - fecha_vencimiento_factura_anterior).to_i)-1)*corriente
            end
            corriente = 0
          else
            corriente = corriente - importe
            if (pago.fecha - fecha_vencimiento_factura_anterior).to_i > 0
              recargo = recargo + (tea**((pago.fecha - fecha_vencimiento_factura_anterior).to_i)-1)*importe
            end
            importe = 0
          end
        end
        total_recargo = total_recargo + recargo
      end

      recargo = 0
      if saldo > 0
        if (fecha_factura - fecha_factura_anterior).to_i > 0
          recargo = (tea**((fecha_factura - fecha_factura_anterior).to_i)-1)*saldo
        end
        saldo = 0
      end

      if corriente > 0
        if (fecha_factura - fecha_vencimiento_factura_anterior).to_i > 0
          recargo = recargo + (tea**((fecha_factura - fecha_vencimiento_factura_anterior).to_i)-1)*corriente
        end
        corriente = 0
      end
      
      total_recargo = total_recargo + recargo

      if total_recargo > 0
        ActiveRecord::Base.connection.execute( 
         "INSERT INTO movimientos (fecha,cuenta_id,descripcion,debe,haber,tipo,ejercicio,rubro_id,generado,created_at,updated_at) VALUES ('#{fecha_factura}',#{cuenta_id},'RECARGOS',#{total_recargo.round},0,1003,#{config.anio},#{rubro.id},true,now(),now());" 
        )
      end
    end
  end

  def self.eliminar_recargos()

    rubro = Rubro.find_by(nombre: "Intereses por atraso")
    config = Config.find(1)

    ActiveRecord::Base.connection.execute( 
      "DELETE FROM movimientos WHERE generado AND rubro_id=#{rubro.id} AND fecha='#{config.fecha_facturacion}';"
    )

  end  

  def self.generar_facturacion()

    config = Config.find(1)
    fecha_vencimiento = config.fecha_facturacion + 9.days

    ActiveRecord::Base.connection.execute( 
      "INSERT INTO facturas (cuenta_id,total,fecha,fecha_vencimiento,mail,created_at,updated_at) " +
      "(SELECT mov.cuenta_id,mov.suma,'#{config.fecha_facturacion}','#{fecha_vencimiento}',false,now(),now() FROM " +
      "(SELECT cuenta_id,SUM(debe-haber) as suma FROM movimientos WHERE fecha<='#{config.fecha_facturacion}' GROUP BY cuenta_id) as mov " +
      "WHERE mov.suma>0 ORDER BY mov.cuenta_id); " +

      "INSERT INTO linea_facturas (factura_id,indice,alumno_id,descripcion,importe,created_at,updated_at) " +
      "SELECT facturas.id,row_number() OVER " +
      "( " +
      " PARTITION BY facturas.id " +
      " ORDER BY lineas.tipo, lineas.alumno, lineas.descripcion " +
      " ) as indice,lineas.alumno,lineas.descripcion,lineas.suma,now(),now() " +
      "FROM " +
      "(SELECT * " +
      "FROM " +
      "((SELECT cuenta_id,NULL as alumno,'SALDO ANTERIOR' as descripcion,0 as tipo,saldo.suma " +
      "FROM " +
      "(SELECT cuenta_id,SUM(debe-haber) as suma FROM movimientos WHERE fecha<'#{config.fecha_facturacion}' GROUP BY cuenta_id) AS saldo " +
      "WHERE " +
      "saldo.suma!=0 AND cuenta_id IN (SELECT cuenta_id FROM facturas WHERE fecha='#{config.fecha_facturacion}' AND NOT cuenta_id IS NULL) " +
      ") " +
      "UNION " +
      "( " +
      "SELECT cuenta_id,alumno,descripcion,tipo,debe FROM movimientos WHERE fecha='#{config.fecha_facturacion}' AND debe!=0 AND cuenta_id IN (SELECT cuenta_id FROM facturas WHERE fecha='#{config.fecha_facturacion}' AND NOT cuenta_id IS NULL) " +
      "ORDER BY cuenta_id " +
      ")) AS movs " +
      "ORDER BY movs.cuenta_id, tipo, alumno, descripcion) AS lineas, " +
      "(SELECT * FROM facturas WHERE fecha='#{config.fecha_facturacion}') AS facturas " +
      "WHERE lineas.cuenta_id=facturas.cuenta_id " +
      "ORDER BY facturas.id, lineas.tipo, lineas.alumno, lineas.descripcion; " +

      "UPDATE linea_facturas SET nombre_alumno='' " + 
      "FROM alumnos " +
      "WHERE factura_id IN (SELECT id FROM facturas WHERE fecha='#{config.fecha_facturacion}') AND alumno_id IS NULL; " +

      "UPDATE linea_facturas SET nombre_alumno=alumnos.nombre " +
      "FROM alumnos " + 
      "WHERE factura_id IN (SELECT id FROM facturas WHERE fecha='#{config.fecha_facturacion}') AND linea_facturas.alumno_id=alumnos.id;"
    )

  end  

  def self.eliminar_facturacion()
    config = Config.find(1)

    ActiveRecord::Base.connection.execute( 
      "DELETE FROM linea_facturas " + 
      "WHERE factura_id IN (SELECT id FROM facturas WHERE fecha=#{config.fecha_facturacion}); " +

      "DELETE FROM facturas WHERE fecha=#{config.fecha_facturacion}); " + 

      "SELECT setval('linea_facturas_id_seq', (SELECT MAX(id) FROM linea_facturas)); " +

      "SELECT setval('facturas_id_seq', (SELECT MAX(id) FROM facturas));"
    )

  end

  def self.habilitar_facturacion()

    ActiveRecord::Base.connection.execute( 
      "UPDATE configs SET fecha_descarga=fecha_facturacion;"
    )

    # Enviar mails
  end



end
