ActiveAdmin.register_page "Ejecutar" do

  menu priority: 301, label: "Ejecutar", parent: "Facturación"



  page_action :brou, method: :post do   

    fecha = Config.find(1).fecha_facturacion

    file_name = "brou.txt"
    file = Tempfile.new(file_name)    
    File.open(file, "w+") do |f|
      f.write("#{fecha}\r\n")



       # vencimiento = "12/08/2019" #no puede ser sabado
       # inicio = "01/08/2019"        
       # titulo = "FACTURACION AGO/2019"
       # dia = 12           #no puede ser sabado
       # mes = 8
       # anio = 2019
       # cantidad = 0
       # suma = 0
       # Factura.where("cuenta_id IN (SELECT id FROM cuentas WHERE brou) AND fecha='2019-08-01'").each do |x|   #11869,11601,11624,11795,12037,12776,13857
       #   cuenta = x.cuenta_id
       #   nombre = Cuenta.where("id=#{x.cuenta_id}").first.nombre
       #   importe = x.total
       #   factura = x.id

       #   str = ("#{nombre} -DEB.AUT.BROU" + ' ' * 48)[0,48]
       #   suma = suma + importe 
       #   cantidad = cantidad+1
       #   f.write("1 00100#{(anio%100).to_s.rjust(2, "0")}#{mes.to_s.rjust(2, "0")}#{dia.to_s.rjust(2, "0")}#{cuenta}000000000000450798A00000000000#{(anio%100).to_s.rjust(2, "0")}#{mes.to_s.rjust(2, "0")}00000#{(importe*100).round(0).to_i.to_s.rjust(10, "0")}0000000000000#{str}0000000000000000000000000000000000000000000000000000000000\r\n" )
       # end
       # f.write("2 00100#{(anio%100).to_s.rjust(2, "0")}#{mes.to_s.rjust(2, "0")}#{dia.to_s.rjust(2, "0")}0000#{cantidad.to_s.rjust(2, "0")}00000000#{(suma*100).round(0).to_i.to_s.rjust(10, "0")}00000000000000000000000000000000000000000000000000000000000000000000000000000000111111111110000000000000000000000000000000000000000000000000000000000\r\n")
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