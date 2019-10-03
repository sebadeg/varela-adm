ActiveAdmin.register_page "Ejecutar" do

  menu priority: 301, label: "Ejecutar", parent: "Facturación"

  page_action :actualizar_fechas, method: :post do
    ActiveRecord::Base.connection.execute( 
      "UPDATE configs SET " + 
      "fecha_facturacion='#{params[:fecha_facturacion]}'," +
      "fecha_pagos='#{params[:fecha_pagos]}'," + 
      "fecha_descarga='#{params[:fecha_descarga]}';" 
    )
    redirect_to admin_ejecutar_path, notice: "Fecha de pagos actualizada"
  end

  page_action :generar_recargos, method: :post do

    config = Config.find(1)

    fecha_factura = config.fecha_facturacion
    fecha_factura_anterior = fecha_factura - 1.month #DateTime.new(2019,05,01)
    fecha_vencimiento_factura_anterior = fecha_factura_anterior + 9.days #DateTime.new(2019,05,10)

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

      if cuenta_id != 9493
          next
      end

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
         "INSERT INTO movimientos (fecha,cuenta_id,descripcion,debe,haber,tipo,rubro_id,created_at,updated_at) VALUES ('#{fecha_factura}',#{cuenta_id},'RECARGOS',#{total_recargo.round},0,1003,#{rubro.id},now(),now());" 
        )
      end
    end

    redirect_to admin_ejecutar_path, notice: "Calculo de recargos hecho!"
  end

  page_action :eliminar_recargos, method: :post do

  end

  page_action :generar_facturacion, method: :post do

  end

  page_action :eliminar_facturacion, method: :post do

  end

  require 'spreadsheet'

  page_action :sistarbanc, method: :post do   

    fecha_facturacion = Config.find(1).fecha_facturacion
    fecha_vencimiento = fecha_facturacion + 9.days
    mes = fecha_vencimiento.month
    anio = fecha_vencimiento.year
    cantidad = 1

    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet

    sheet.row(0).push "Año","Mes","Secuencial","Referencia","Nombre","Moneda","Importe","Fecha Vto.","Fecha Inicio"
    Factura.where("fecha='#{fecha_facturacion}'").order(:cuenta_id).each do |x|
      cuenta = x.cuenta_id
      nombre = Cuenta.where("id=#{x.cuenta_id}").first.nombre
      importe = x.total

      sheet.row(cantidad).push anio,mes,0,cuenta,"#{nombre}",0,importe,fecha_vencimiento.strftime("%d/%m/%Y"),fecha_facturacion.strftime("%d/%m/%Y")

      cantidad = cantidad+1
    end

    file_name = "redpafac.xls"
    file = Tempfile.new(file_name)
    book.write file

    send_file(
      file.path,
      filename: file_name,
      type: "application/xls"
    )

    
    # fecha_facturacion = Config.find(1).fecha_facturacion
    # fecha_vencimiento = fecha_facturacion + 9.days
    # mes = fecha_vencimiento.month
    # anio = fecha_vencimiento.year

    # file_name = "redpafac.txt"
    # file = Tempfile.new(file_name)    
    # File.open(file, "w+") do |f|

    #   f.write("Año;Mes;Secuencial;Referencia;Nombre;Moneda;Importe;Fecha Vto.;Fecha Inicio;\r\n")
    #   Factura.where("fecha='#{fecha_facturacion}'").order(:cuenta_id).each do |x|
    #     cuenta = x.cuenta_id
    #     nombre = Cuenta.where("id=#{x.cuenta_id}").first.nombre
    #     importe = x.total

    #     f.write("#{anio};#{mes};0;#{cuenta};#{nombre};0;#{importe};#{fecha_vencimiento};#{fecha_facturacion};\r\n")
    #   end
    # end

    # send_file(
    #   file.path,
    #   filename: file_name,
    #   type: "application/txt"
    # )

  end

  page_action :brou, method: :post do   

    fecha_facturacion = Config.find(1).fecha_facturacion
    fecha_vencimiento = fecha_facturacion + 9.days

    if fecha_vencimiento.wday == 0
      fecha_vencimiento = fecha_vencimiento + 1.days
    elsif fecha_vencimiento.wday == 6
      fecha_vencimiento = fecha_vencimiento + 2.days
    end

    #titulo = "FACTURACION #{fecha_facturacion.strftime("%b").upcase}/#{fecha_facturacion.strftime("%Y")}"
    dia = fecha_vencimiento.day
    mes = fecha_vencimiento.month
    anio = fecha_vencimiento.year

    cantidad = 0
    suma = 0

    file_name = "BORU-DEBAUT4507.txt"
    file = Tempfile.new(file_name)    
    File.open(file, "w+") do |f|
      Factura.where("cuenta_id IN (SELECT id FROM cuentas WHERE brou) AND fecha='#{fecha_facturacion}'").each do |x|
        cuenta = x.cuenta_id
        nombre = Cuenta.where("id=#{x.cuenta_id}").first.nombre
        importe = x.total
        factura = x.id

        str = ("#{nombre} -DEB.AUT.BROU" + ' ' * 48)[0,48]
        suma = suma + importe 
        cantidad = cantidad+1
        f.write("1 00100#{(anio%100).to_s.rjust(2, "0")}#{mes.to_s.rjust(2, "0")}#{dia.to_s.rjust(2, "0")}#{cuenta}000000000000450798A00000000000#{(anio%100).to_s.rjust(2, "0")}#{mes.to_s.rjust(2, "0")}00000#{(importe*100).round(0).to_i.to_s.rjust(10, "0")}0000000000000#{str}0000000000000000000000000000000000000000000000000000000000\r\n" )
      end
      f.write("2 00100#{(anio%100).to_s.rjust(2, "0")}#{mes.to_s.rjust(2, "0")}#{dia.to_s.rjust(2, "0")}0000#{cantidad.to_s.rjust(2, "0")}00000000#{(suma*100).round(0).to_i.to_s.rjust(10, "0")}00000000000000000000000000000000000000000000000000000000000000000000000000000000111111111110000000000000000000000000000000000000000000000000000000000\r\n")
    end

    send_file(
        file.path,
        filename: file_name,
        type: "application/txt"
      )
  end

  content do
    render partial: 'ejecutar'
  end

end