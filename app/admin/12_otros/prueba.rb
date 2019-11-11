ActiveAdmin.register_page "Prueba" do

  menu priority: 1211, label: "Prueba", parent: 'Otros'

  def ChequearUsuario(cedula,nombre,apellido,email,domicilio,celular,lugar_nacimiento,fecha_nacimiento,profesion,trabajo,telefono_trabajo)
    
    if cedula == nil || email == nil 
      return
    end

    p "--------------------------------------------------"
    p "--------------------------------------------------"
    p "--------------------------------------------------"
    p "--------------------------------------------------"
    p "--------------------------------------------------"

    usuario = Usuarios.find(cedula: cedula) rescue nil
    if usuario != nil
    	p "Existe #{cedula} - #{nombre} #{apellido}"
    else
    	p "Falta #{cedula} - #{nombre} #{apellido}"
    end

    # if usuario != nil
    #   usuario.email = email
    #   usuario.cedula = cedula
    #   usuario.nombre = nombre
    #   usuario.apellido = apellido
    #   usuario.direccion = direccion
    #   usuario.celular = celular
    #   usuario.lugar_nacimiento = lugar_nacimiento
    #   usuario.fecha_nacimiento = fecha_nacimiento
    #   usuario.profesion = profesion
    #   usuario.trabajo = trabajo
    #   usuario.telefono_trabajo = telefono_trabajo
    #   usuario.save!
    # end
    p "--------------------------------------------------"
    p "--------------------------------------------------"
    p "--------------------------------------------------"
    p "--------------------------------------------------"
    p "--------------------------------------------------"

    return
  end

  page_action :chequear_usuarios, method: :post do

    Inscripcion.where("")


    Inscripcion.where("NOT reinscripcion").each do |inscripcion|

      ChequearUsuario(inscripcion.cedula_padre,inscripcion.nombre_padre,inscripcion.apellido_padre,
      	inscripcion.email_padre,inscripcion.domicilio_padre,inscripcion.celular_padre,
        inscripcion.lugar_nacimiento_padre,inscripcion.fecha_nacimiento_padre,inscripcion.profesion_padre,
        inscripcion.trabajo_padre,inscripcion.telefono_trabajo_padre)
      ChequearUsuario(inscripcion.cedula_madre,inscripcion.nombre_madre,inscripcion.apellido_madre,
      	inscripcion.email_madre,inscripcion.domicilio_madre,inscripcion.celular_madre,
        inscripcion.lugar_nacimiento_madre,inscripcion.fecha_nacimiento_madre,inscripcion.profesion_madre,
        inscripcion.trabajo_madre,inscripcion.telefono_trabajo_madre)
      ChequearUsuario(inscripcion.documento1,inscripcion.nombre1,inscripcion.apellido1,inscripcion.email1,
      	inscripcion.domicilio1,inscripcion.celular1,nil,nil,nil,nil,nil)
      ChequearUsuario(inscripcion.documento2,inscripcion.nombre2,inscripcion.apellido2,inscripcion.email2,
      	inscripcion.domicilio2,inscripcion.celular2,nil,nil,nil,nil,nil)

      # if inscripcion.titular_padre
      #   ChequearTitular(inscripcion.anio,inscripcion.cedula_padre,inscripcion.cedula)
      # end
      # if inscripcion.titular_madre
      #   ChequearTitular(inscripcion.anio,inscripcion.cedula_madre,inscripcion.cedula)
      # end
      # ChequearTitular(inscripcion.anio,inscripcion.documento1,inscripcion.cedula)
      # ChequearTitular(inscripcion.anio,inscripcion.documento2,inscripcion.cedula)

      # ChequearPadre(inscripcion.cedula_padre,inscripcion.cedula)
      # ChequearPadre(inscripcion.cedula_madre,inscripcion.cedula)

    end

  end

  content do
    render partial: 'prueba'
  end

end