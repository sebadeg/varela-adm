ActiveAdmin.register_page "Ejecutar" do

  menu priority: 301, label: "Ejecutar", parent: "Facturación"


  page_action :recargos, method: :post do

  end

  page_action :facturar, method: :post do

  end

  page_action :sistarbanc, method: :post do   
    
    fecha_facturacion = Config.find(1).fecha_facturacion
    fecha_vencimiento = fecha_facturacion + 9.days
    mes = fecha_vencimiento.month
    anio = fecha_vencimiento.year

    file_name = "sistarbanc.txt"
    file = Tempfile.new(file_name)    
    File.open(file, "w+") do |f|

      f.write("Año;Mes;Secuencial;Referencia;Nombre;Moneda;Importe;Fecha Vto.;Fecha Inicio;\r\n")
      Factura.where("fecha='#{fecha_facturacion}'").order(:cuenta_id).each do |x|
        cuenta = x.cuenta_id
        nombre = Cuenta.where("id=#{x.cuenta_id}").first.nombre
        importe = x.total

        f.write("#{anio};#{mes};0;#{cuenta};#{nombre};0;#{importe};#{fecha_vencimiento};#{fecha_facturacion};\r\n")
      end
    end
    send_file(
      file.path,
      filename: file_name,
      type: "application/txt"
    )
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

    file_name = "brou.txt"
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