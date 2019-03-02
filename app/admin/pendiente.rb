ActiveAdmin.register_page "Pendiente" do

  menu priority: 70, label: "Pendiente"


  page_action :passwordusuario, method: :post do

    usuarios = Usuario.where( "mail IS NULL OR mail=false") rescue nil    
    if ( usuarios != nil )
      usuarios.each do |usuario|
        passwd =  Digest::MD5.hexdigest(usuario.cedula.to_s + DateTime.now.strftime('%Y%m%d%H%M%S'))[0..7]
        ActiveRecord::Base.connection.execute( "UPDATE usuarios SET passwd='#{passwd}' WHERE id=#{usuario.id};" )
        usuario.update( password: passwd, password_confirmation: passwd );
      end
    end
  end

  page_action :inscribirusuario, method: :post do

    usuarios = Usuario.where( "mail IS NULL OR mail=false").limit(1) rescue nil    
    if ( usuarios != nil )
      usuarios.each do |usuario|
        usuario.update( password: usuario.passwd, password_confirmation: usuario.passwd );
        UserMailer.inscribir_usuario( usuario ).deliver_now
        ActiveRecord::Base.connection.execute( "UPDATE usuarios SET mail=true WHERE id=#{usuario.id};" )
      end
    end
  end

  page_action :enviarfactura, method: :post do

    facturas = Factura.where("fecha='2019-02-01' AND NOT mail").order(:id).limit(5) rescue nil    
    if facturas != nil
      facturas.each do |factura|
        cuenta_id = factura.cuenta_id

        file_path = Rails.root.join("temp", "factura_#{cuenta_id}_#{factura.id}.pdf")
        factura.imprimir(file_path,cuenta_id,factura)
        # send_file(
        #   file.path,
        #   filename: "factura_#{cuenta_id}_#{factura.id}.pdf",
        #   type: "application/pdf"
        # )

        usuarios = Usuario.where( "id IN (SELECT usuario_id FROM titular_cuentas WHERE cuenta_id=#{cuenta_id})") rescue nil
        if ( usuarios != nil )
          usuarios.each do |usuario|
            p usuario.nombre + " " + usuario.apellido + " - " + usuario.email
            UserMailer.facturacion( usuario, "Febrero 2019", cuenta_id, "factura_#{cuenta_id}_#{factura.id}.pdf", file_path ).deliver_now
          end
          ActiveRecord::Base.connection.execute( "UPDATE facturas SET mail=true WHERE id=#{factura.id};" )
        end

      end
    end

    redirect_to admin_pendiente_path, notice: "Hecho"


    # cuenta_id = 12121
    # usuarios = Usuario.where( "id IN (SELECT usuario_id FROM titular_cuentas WHERE cuenta_id=#{cuenta_id})") rescue nil


    # if ( usuarios != nil )
    #   usuarios.each do |usuario|
    #     p usuario.nombre + " " + usuario.apellido + " - " + usuario.email

    #     UserMailer.inscribir_usuario( usuario ).deliver_now
        
    #     ActiveRecord::Base.connection.execute( "UPDATE usuarios SET mail=true WHERE id=#{usuario.id};" )
    #   end
    # end


    # mes = 1
    # cuotas = 12
    # cuenta = 12121
    # alumno = 121211
    # valor = 18202

    # (1..12).each do |x|
    #   ActiveRecord::Base.connection.execute( 
    #     "INSERT INTO movimientos (alumno,cuenta_id,fecha,descripcion,debe,haber,extra,tipo,created_at,updated_at) VALUES " +
    #     "(#{alumno},#{cuenta},'2019-#{mes+x-1}-01','CUOTA 2019 #{x}/#{cuotas}',#{valor},0,'',2,now(),now());" )  
    # end
    

    # mes = 1
    # cuotas = 12
    # cuenta = 12121
    # alumno = 121211
    # valor = 16473

    # (1..12).each do |x|
    #   ActiveRecord::Base.connection.execute( 
    #     "INSERT INTO movimientos (alumno,cuenta_id,fecha,descripcion,debe,haber,extra,tipo,created_at,updated_at) VALUES " +
    #     "(#{alumno},#{cuenta},'2019-#{mes+x-1}-01','CUOTA 2019 #{x}/#{cuotas}',#{valor},0,'',2,now(),now());" )  
    # end

    

    # Factura.each do |f|

    #     i = 1
    #     Movimiento.where( "cuenta_id=#{f.cuenta_id} AND fecha='2019-01-01'" ).order(:tipo) do |movimiento|

    #       ActiveRecord::Base.connection.execute(
    #         "INSERT INTO linea_facturas (factura_id,alumno_id,importe,indice,descripcion,created_at,updated_at) VALUES " +
    #         "(#{f.id},#{m.alumno},#{m.debe},#{i},#{m.descripcion},now(),now());"
    #         )
    #       i=i+1
    #     end
    # end  

    # Movimiento.where( "NOT factura IS NULL" ).each do |movimiento|
    #   (2..movimiento.factura).each do |mes|
    #     fecha = movimiento.fecha >> (mes-1)
    #     ActiveRecord::Base.connection.execute(
    #       "INSERT INTO movimientos (cuenta_id,alumno,fecha,descripcion,debe,haber,extra,tipo,created_at,updated_at) VALUES" +
    #       "(#{movimiento.cuenta_id},#{movimiento.alumno},'#{fecha.year}-#{fecha.month}-#{fecha.day}','CUOTA 2019 #{mes}/#{movimiento.factura}',#{movimiento.debe},0,'',2,now(),now());"
    #     )
    #   end

    #     ActiveRecord::Base.connection.execute(
    #       "UPDATE movimientos SET factura=NULL WHERE id=#{movimiento.id};"
    #     )
    # end
  end

  page_action :sistarbanc, method: :post do   

    file_name = "sistarbanc.txt"
    file = Tempfile.new(file_name)    
    File.open(file, "w+") do |f|
      vencimiento = "10/03/2019"
      inicio = "01/03/2019"
      mes = 3
      anio = 2019
      f.write("Año;Mes;Secuencial;Referencia;Nombre;Moneda;Importe;Fecha Vto.;Fecha Inicio;\r\n")
      Factura.where("fecha='2019-03-01'").each do |x|
        cuenta = x.cuenta_id
        nombre = Cuenta.where("id=#{x.cuenta_id}").first.nombre
        importe = x.total

        f.write("#{anio};#{mes};0;#{cuenta};#{nombre};0;#{importe};#{vencimiento};#{inicio};\r\n")
      end
    end
    send_file(
      file.path,
      filename: file_name,
      type: "application/txt"
    )
  end

  page_action :redpagos, method: :post do   

     file_name = "redpagos.txt"
     file = Tempfile.new(file_name)    
     File.open(file, "w+") do |f|
       vencimiento = "31/03/2019"
       inicio = "01/03/2019"
       mes = 3
       anio = 2019

       f.write("Año;Mes;Secuencial;Referencia;Nombre;Moneda;Importe;Fecha Vto.;Fecha Inicio;\r\n")
      Factura.where("fecha='2019-03-01'").each do |x|
        cuenta = x.cuenta_id
        nombre = Cuenta.where("id=#{x.cuenta_id}").first.nombre
        importe = x.total

        f.write("#{anio};#{mes};0;#{cuenta};#{nombre};0;#{importe};#{vencimiento};#{inicio};\r\n")
      end
	end

    send_file(
        file.path,
        filename: file_name,
        type: "application/txt"
      )
  end

  page_action :abitab, method: :post do   

     file_name = "abitab.txt"
     file = Tempfile.new(file_name)    
     File.open(file, "w+") do |f|

       vencimiento = "31/03/2019"
       inicio = "01/03/2019"
       titulo = "FACTURACION MAR/2019"      

       cantidad = 0
       suma = 0

       f.write("13|16|1\r\n")
      Factura.where("fecha='2019-03-01'").each do |x|
        cuenta = x.cuenta_id
        nombre = Cuenta.where("id=#{x.cuenta_id}").first.nombre
        importe = x.total
         
         cantidad = cantidad + 1
         suma = suma + importe

         str = ("#{nombre}" + ' ' * 30)[0,30]


         f.write("C|JPV|2124|1|1|#{cuenta}|#{str}|#{str}| |1|#{vencimiento}| |#{inicio}|#{importe*100}|000|000|1| | | | | | | | | | | |#{titulo}| | | | | |1\r\n")
       end

       f.write("#|1|#{cantidad}|#{suma*100}\r\n")
 	end

    send_file(
        file.path,
        filename: file_name,
        type: "application/txt"
      )
  end

  page_action :brou, method: :post do   

     file_name = "brou.txt"
     file = Tempfile.new(file_name)    
     File.open(file, "w+") do |f|
       vencimiento = "11/03/2019" #no puede ser sabado
       inicio = "01/03/2019"        
       titulo = "FACTURACION MAR/2019"
       dia = 11           #no puede ser sabado
       mes = 3
       anio = 2019
       cantidad = 0
       suma = 0
       Factura.where("cuenta_id IN (11869,11601,11624,11795,12037,12776,13857) AND fecha='2019-03-01'").each do |x|
         cuenta = x.cuenta_id
         nombre = Cuenta.where("id=#{x.cuenta_id}").first.nombre
         importe = x.total
         factura = x.id

         str = ("#{nombre} -DEB.AUT.BROU" + ' ' * 48)[0,48]
         suma = suma + importe 
         cantidad = cantidad+1
         f.write("1 00100#{(anio%100).to_s.rjust(2, "0")}#{mes.to_s.rjust(2, "0")}#{dia.to_s.rjust(2, "0")}#{cuenta}000000000000450798A00000000000#{(anio%100).to_s.rjust(2, "0")}#{mes.to_s.rjust(2, "0")}00000#{(importe*100).round(0).to_s.rjust(10, "0")}0000000000000#{str}0000000000000000000000000000000000000000000000000000000000\r\n" )
       end
       f.write("2 00100#{(anio%100).to_s.rjust(2, "0")}#{mes.to_s.rjust(2, "0")}#{dia.to_s.rjust(2, "0")}0000#{cantidad.to_s.rjust(2, "0")}00000000#{(suma*100).round(0).to_s.rjust(10, "0")}00000000000000000000000000000000000000000000000000000000000000000000000000000000111111111110000000000000000000000000000000000000000000000000000000000\r\n")
	end

    send_file(
        file.path,
        filename: file_name,
        type: "application/txt"
      )
  end


  page_action :ingreso, method: :post do
    
    #SELECT * FROM inscripciones WHERE alumno_id NOT IN (SELECT alumno_id FROM cuenta_alumnos WHERE NOT alumno_id IS NULL)

    
      CuentaAlumno.where( "cuenta_id NOT IN (SELECT cuenta_id FROM titular_cuentas WHERE NOT cuenta_id IS NULL) AND " + 
                          "cuenta_id IN (SELECT cuenta_id FROM inscripciones WHERE NOT cuenta_id IS NULL)").each do |cuenta_alumno|
        
        inscripcion = Inscripcion.find_by(cuenta_id:cuenta_alumno.cuenta_id)
        if ( inscripcion != nil )
          if inscripcion.documento1 && inscripcion.email1
            Usuario.create(cedula: inscripcion.documento1, email:inscripcion.email1, nombre: inscripcion.nombre1, cuenta: inscripcion.cuenta_id )
          end
          if inscripcion.documento2 && inscripcion.email2
            Usuario.create(cedula: inscripcion.documento2, email:inscripcion.email2, nombre: inscripcion.nombre2, cuenta: inscripcion.cuenta_id )
          end
          if inscripcion.titular_padre && inscripcion.cedula_padre && inscripcion.email_padre
             Usuario.create(cedula: inscripcion.cedula_padre, email:inscripcion.email_padre, nombre: inscripcion.nombre_padre, cuenta: inscripcion.cuenta_id )
         end
          if inscripcion.titular_madre && inscripcion.cedula_madre && inscripcion.email_madre
            Usuario.create(cedula: inscripcion.cedula_madre, email:inscripcion.email_madre, nombre: inscripcion.nombre_madre, cuenta: inscripcion.cuenta_id  )
          end
        end

      end

    #SELECT * FROM cuenta_alumnos INNER JOIN inscripciones ON cuenta_alumnos.alumno_id=inscripciones.alumno_id WHERE cuenta_alumnos.cuenta_id NOT IN (SELECT cuenta_id FROM titular_cuentas WHERE NOT cuenta_id IS NULL)
  end





 #  page_action :redpagos, method: :post do   
 #    #ActiveRecord::Base.connection.execute( "UPDATE movimientos SET pendiente=false WHERE cuenta_id=#{cuenta} AND fecha<='2018-06-01'" )
    
 #    file_name = "redpagos.txt"
 #    file = Tempfile.new(file_name)    
 #    File.open(file, "w+") do |f|

 #      f.write("Año;Mes;Secuencial;Referencia;Nombre;Moneda;Importe;Fecha Vto.;Fecha Inicio;\n")
 #      (1..10).each do |x|
 #        cuenta = 12121
 #        nombre = "CECILIA"
 #        apellido = "SAETTONE"
 #        importe = 34000
 #        vencimiento = "10/01/2019"
 #        inicio = "01/01/2019"
 #        dia = 10
 #        mes = 1
 #        anio = 2019

 #        f.write("#{anio};#{mes};0;#{cuenta};#{apellido}, #{nombre};0;#{importe};#{vencimiento};#{inicio};\n")
 #      end
	# end

 #    send_file(
 #        file.path,
 #        filename: file_name,
 #        type: "application/txt"
 #      )
 #  end

 #  page_action :abitab, method: :post do   
 #    #ActiveRecord::Base.connection.execute( "UPDATE movimientos SET pendiente=false WHERE cuenta_id=#{cuenta} AND fecha<='2018-06-01'" )
    
 #    file_name = "abitab.txt"
 #    file = Tempfile.new(file_name)    
 #    File.open(file, "w+") do |f|
 #      f.write("13|16|1\n")
      
 #      (1..10).each do |x|
 #        cuenta = 12121
 #        nombre = "CECILIA"
 #        apellido = "SAETTONE"
 #        importe = 34000
 #        vencimiento = "10/01/2019"
 #        inicio = "01/01/2019"
 #        titulo = "FACTURACION ENE/2019"
 #        f.write("C|JPV|2124|1|1|#{cuenta}|#{nombre}|#{apellido}| |1|#{vencimiento}| |#{inicio}|#{importe*100}|000|000|1| | | | | | | | | | | |#{titulo}| | | | | |1")
 #      end

 #      f.write("#|1|406|925667116\n")
	# end

 #    send_file(
 #        file.path,
 #        filename: file_name,
 #        type: "application/txt"
 #      )
 #  end

 #  page_action :brou, method: :post do   
 #    #ActiveRecord::Base.connection.execute( "UPDATE movimientos SET pendiente=false WHERE cuenta_id=#{cuenta} AND fecha<='2018-06-01'" )
    
 #    file_name = "brou.txt"
 #    file = Tempfile.new(file_name)    
 #    File.open(file, "w+") do |f|
 #      suma = 0
 #      (1..10).each do |x|
 #        cuenta = 12121
 #        nombre = "CECILIA"
 #        apellido = "SAETTONE"
 #        importe = 34000
 #        vencimiento = "10/01/2019"
 #        inicio = "01/01/2019"        
 #        titulo = "FACTURACION ENE/2019"
 #        dia = 10
 #        mes = 1
 #        anio = 2019
 #        factura = 450798
 #        str = ("#{apellido}, #{nombre} -DEB.AUT.BROU" + ' ' * 48)[0,47]
	# 	suma = suma + importe 

 #        f.write("1 00100#{(anio%100).to_s.rjust(2, "0")}#{mes.to_s.rjust(2, "0")}#{dia.to_s.rjust(2, "0")}#{cuenta}000000000000#{factura}A00000000000#{(anio%100).to_s.rjust(2, "0")}#{mes.to_s.rjust(2, "0")}00000#{(importe*100).round(0).to_s.rjust(10, "0")}0000000000000#{str}0000000000000000000000000000000000000000000000000000000000\n" )

 #      end
 #      f.write("2 00100#{(anio%100).to_s.rjust(2, "0")}#{mes.to_s.rjust(2, "0")}#{dia.to_s.rjust(2, "0")}00001000000000#{(importe*100).round(0).to_s.rjust(10, "0")}00000000000000000000000000000000000000000000000000000000000000000000000000000000111111111110000000000000000000000000000000000000000000000000000000000"
	# end

 #    send_file(
 #        file.path,
 #        filename: file_name,
 #        type: "application/txt"
 #      )
 #  end


  content do
    render partial: 'pendiente'
  end



#  page_action :validar, method: :post do  	
#  	cuenta = eval(params[:cuenta])[:value]
#	ActiveRecord::Base.connection.execute( "UPDATE movimientos SET pendiente=false WHERE cuenta_id=#{cuenta} AND fecha<='2018-06-01'" )
#    redirect_to admin_pendiente_path, notice: "Cuenta validada: #{cuenta}"
#  end

#  content do
#    render partial: 'pendiente', locals:
#    {
#      cuentas: Cuenta.where("id IN (SELECT cuenta_id FROM movimientos WHERE fecha<='2018-06-01' AND pendiente)").order(id),
#      usuarios: Usuario.where("cuenta IN (SELECT cuenta_id FROM movimientos WHERE fecha<='2018-06-01' AND pendiente)").order(id)
#    }
#  end

end