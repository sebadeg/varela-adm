ActiveAdmin.register_page "Ejecutar" do

  menu priority: 301, label: "Ejecutar", parent: "Facturación"


  page_action :generar_facturacion, method: :post do

    fecha = params[:fecha_facturacion].to_datetime

    if !Factura.verificar_fecha_facturacion(fecha)
      redirect_to admin_ejecutar_path, notice: "Error en fecha de facturación!"
      return;
    end

    fecha_facturacion = DateTime.new(fecha.year,fecha.month,1)

    ActiveRecord::Base.connection.execute( 
      "UPDATE configs SET " + 
      "fecha_facturacion='#{fecha_facturacion}'," +
      "fecha_pagos='#{params[:fecha_pagos]}';" 
    )

    Factura.generar_recargos()
    Factura.generar_facturacion()

    redirect_to admin_ejecutar_path, notice: "Facturación generada!"
  end

  page_action :eliminar_facturacion, method: :post do
  
    config = Config.find(1)

    if !Factura.verificar_fecha_facturacion(config.fecha_facturacion)
      redirect_to admin_ejecutar_path, notice: "Error en fecha de facturación!"
      return;
    end

    Factura.eliminar_recargos()
    Factura.eliminar_facturacion()

    redirect_to admin_ejecutar_path, notice: "Facturación eliminada!"
  end

  page_action :habilitar_facturacion, method: :post do
    Factura.habilitar_facturacion()

    redirect_to admin_ejecutar_path, notice: "Facturación habilitada!"
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

  page_action :prueba, method: :post do   

    file_name = "Salida.txt"
    file = Tempfile.new(file_name)    
    File.open(file, "w+") do |f|

      Socio.all.order(:id).each do |x|
        celular = ""
        if x.celular != nil 
          celular = "#{x.celular}"
        end
        if x.telefono != nil 
          if celular != "" 
            celular = celular + "/"
          end
          celular = celular + x.telefono
        end

        fecha_ingreso = ""
        if x.fecha_ingreso != nil
          fecha_ingreso = x.fecha_ingreso.strftime("%Y-%m-%d")
        end
        fecha_egreso = ""
        if x.fecha_egreso != nil
          fecha_egreso = x.fecha_egreso.strftime("%Y-%m-%d")
        end

        f.write(
          "Socio.create(" +
            "id: #{x.id}," +
            "cedula: #{x.cedula}," +
            "nombre: '#{x.nombre}'," +
            "apellido: '#{x.apellido}'," +
            "email: '#{x.email}'," +
            "domicilio: '#{x.domicilio}'," +
            "celular: '#{celular}'," +
            "fecha_ingreso: '#{fecha_ingreso}'," +
            "fecha_egreso: '#{fecha_egreso}'" +
          ")\r\n"
        )
      end

      CuotaSocio.all.order(:fecha,:socio_id).each do |x|

        fecha = ""
        if x.fecha != nil
          fecha = x.fecha.strftime("%Y-%m-%d")
        end


        f.write(
          "CuotaSocio.create(" +
            "socio_id: #{x.socio_id}," +
            "fecha: '#{fecha}'," +
            "concepto: '#{x.concepto}'," +
            "importe: #{x.importe}" +
          ")\r\n"
        )
      end


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