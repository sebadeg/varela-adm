ActiveAdmin.register Inscripcion do

  menu priority: 601, label: "Inscripciones", parent: "Inscripciones"

  permit_params :fecha, :recibida, :reinscripcion, :anio, 
    :nombre,:apellido,:cedula,:lugar_nacimiento,:fecha_nacimiento,:domicilio,:celular,:mutualista,:emergencia,:procede,
    :proximo_grado_id,:formulario_id,:convenio_id,:adicional_id,:matricula_id,:hermanos_id,:cuotas_id,
    :nombre_padre,:apellido_padre,:cedula_padre,:lugar_nacimiento_padre,:fecha_nacimiento_padre,:email_padre,:domicilio_padre,:celular_padre,:profesion_padre,:trabajo_padre,:telefono_trabajo_padre,:titular_padre,
    :nombre_madre,:apellido_madre,:cedula_madre,:lugar_nacimiento_madre,:fecha_nacimiento_madre,:email_madre,:domicilio_madre,:celular_madre,:profesion_madre,:trabajo_madre,:telefono_trabajo_madre,:titular_madre,
    :nombre1,:apellido1,:documento1,:domicilio1,:email1,:celular1,
    :nombre2,:apellido2,:documento2,:domicilio2,:email2,:celular2,:precio_anterior

  scope :todos
  scope :inscripciones
  scope :reinscripciones



  action_item :habilitar, only: :show do
    if inscripcion.inhabilitado
      link_to "Habilitar", habilitar_admin_inscripcion_path(inscripcion), method: :put 
    else
      link_to "Inhabilitar", habilitar_admin_inscripcion_path(inscripcion), method: :put   
    end
  end

  action_item :registrar, only: :show do
    if inscripcion.registrado
      link_to "Desregistrar", registrar_admin_inscripcion_path(inscripcion), method: :put   
    else
      link_to "Registrar", registrar_admin_inscripcion_path(inscripcion), method: :put 
    end
  end

  action_item :generar_vale, only: :show do
    if inscripcion.hay_vale
      link_to "Quitar vale", generar_vale_admin_inscripcion_path(inscripcion), method: :put   
    else
      link_to "Generar vale", generar_vale_admin_inscripcion_path(inscripcion), method: :put 
    end
  end


  action_item :inscribir, only: :show do
    if inscripcion.inscripto
      link_to "Desinscribir", inscribir_admin_inscripcion_path(inscripcion), method: :put 
    else
      link_to "Inscribir", inscribir_admin_inscripcion_path(inscripcion), method: :put 
    end
  end

  member_action :habilitar, method: :put do
    id = params[:id]
    inscripcion = Inscripcion.find(id)
    ActiveRecord::Base.connection.execute( "UPDATE inscripciones SET inhabilitado=#{!inscripcion.inhabilitado} WHERE id=#{id};" )
    redirect_to admin_inscripcion_path(inscripcion)
  end

  member_action :registrar, method: :put do
    id = params[:id]
    inscripcion = Inscripcion.find(id)
    ActiveRecord::Base.connection.execute( "UPDATE inscripciones SET registrado=#{!inscripcion.registrado} WHERE id=#{id};" )
    redirect_to admin_inscripcion_path(inscripcion)
  end

  member_action :generar_vale, method: :put do
    id = params[:id]
    inscripcion = Inscripcion.find(id)
    if inscripcion.hay_vale == nil || !inscripcion.hay_vale
      ActiveRecord::Base.connection.execute( "UPDATE inscripciones SET hay_vale=true WHERE id=#{id};" )

      TitularCuenta.where("cuenta_id=#{inscripcion.cuenta_id}").each do |titular_cuenta|
        usuario = Usuario.find(titular_cuenta.usuario_id)
        UserMailer.hay_vale_usuario(usuario).deliver_now
      end

    else
      ActiveRecord::Base.connection.execute( "UPDATE inscripciones SET hay_vale=false WHERE id=#{id};" )
    end

    redirect_to admin_inscripcion_path(inscripcion)
  end


  member_action :inscribir, method: :put do
    id = params[:id]
    inscripcion = Inscripcion.find(id)
    ActiveRecord::Base.connection.execute( "UPDATE inscripciones SET inscripto=#{!inscripcion.inscripto} WHERE id=#{id};" )
    redirect_to admin_inscripcion_path(inscripcion_alumno)
  end


  action_item :formulario, only: :show do
    link_to "Formulario y Vale", formulario_admin_inscripcion_path(inscripcion), method: :put 
  end

  member_action :formulario, method: :put do
    id = params[:id]
    inscripcion = Inscripcion.find(id)
  
    file_name = "Inscripcion #{inscripcion.nombre} #{inscripcion.apellido}.pdf"
    file = Tempfile.new(file_name)
    inscripcion.vale(file.path)

    send_file(
        file.path,
        filename: file_name,
        type: "application/pdf"
      )
    
  end

  index do
  	#selectable_column
    column :nombre
    column :apellido
    column :cedula
    column :cuenta_id
    column :alumno_id
    column :anio
    column "Modificado" do |r| r.updated_at == nil ? "" : I18n.l(r.updated_at, format: '%d/%m/%Y %H:%M:%S') end

    actions
  end

  filter :nombre
  filter :apellido
  filter :cedula
  filter :reinscripcion
  filter :anio
  filter :cuenta_id
  filter :alumno_id

  filter :inhabilitado
  filter :registrado
  filter :inscripto
  filter :hay_vale

  show do

    def find(arr,v)
      arr.each do |a|
        if a[1]==v
          return a[0]
        end
      end
      return ""
    end

    attributes_table title:"Alumno" do
      row :nombre
      row :apellido
      row :cedula
      row :cuenta_id
      row :alumno_id
      row :lugar_nacimiento
      row :fecha_nacimiento
      row :domicilio
      row :celular
      row :mutualista
      row :emergencia
      row :procede
    end

    attributes_table title:"Inscripción" do
      row "Fecha" do |r| I18n.l(r.created_at, format: '%-d de %B de %Y') end
      row :recibida
      row :anio
      row "Grado" do |r| (r.proximo_grado != nil ? "#{r.proximo_grado.nombre} - $U #{r.proximo_grado.precio}" : "") end      
      row "Formulario" do |r| r.Formulario() end
      row "Convenio" do |r| r.FindInscripcionOpcion(r.convenio_id) end 
      row "Adicional" do |r| r.FindInscripcionOpcion(r.adicional_id) end
      row "Matrícula" do |r| r.FindInscripcionOpcion(r.matricula_id) end
      row "Hermanos" do |r| r.FindInscripcionOpcion(r.hermanos_id) end
      row "Cuotas" do |r| r.FindInscripcionOpcion(r.cuotas_id) end

      row "Precio 2020" do |r| r.CalcularPrecioToStr() end
      row "Precio 2019" do |r| r.CalcularPrecioAnteriorToStr() end
      row :precio_anterior
      
      row "Coeficiente contra 2019" do |r| r.CalcularPrecioAnteriorTotal()*1.0/r.CalcularPrecioTotal() end
      row "Coeficiente contra Precio" do |r| r.precio_anterior == nil ? nil : r.precio_anterior*1.0/r.CalcularPrecioTotal()  end
    end

    attributes_table title:"Padre" do
      row :nombre_padre
      row :apellido_padre
      row :cedula_padre
      row :lugar_nacimiento_padre
      row :fecha_nacimiento_padre
      row :email_padre
      row :domicilio_padre
      row :celular_padre
      row :profesion_padre
      row :trabajo_padre
      row :telefono_trabajo_padre
      row :titular_padre
    end

    attributes_table title:"Madre" do
      row :nombre_madre
      row :apellido_madre
      row :cedula_madre
      row :lugar_nacimiento_madre
      row :fecha_nacimiento_madre
      row :email_madre
      row :domicilio_madre
      row :celular_madre
      row :profesion_madre
      row :trabajo_madre
      row :telefono_trabajo_madre
      row :titular_madre
    end

    attributes_table title:"Titular 1" do
      row :nombre1
      row :apellido1
      row :documento1
      row :domicilio1
      row :email1
      row :celular1
    end

    attributes_table title:"Titular 2" do
      row :nombre2
      row :apellido2
      row :documento2
      row :domicilio2
      row :email2
      row :celular2
    end
  end

  form do |f|    
    if f.object.new_record?
      f.input :recibida, input_html: { value: current_admin_usuario.email }, as: :hidden
      f.input :reinscripcion, input_html: { value: false }, as: :hidden
    end

    f.inputs "Alumno" do
      f.input :nombre
      f.input :apellido
      f.input :cedula
      f.input :lugar_nacimiento
      f.input :fecha_nacimiento
      f.input :domicilio
      f.input :celular
      f.input :mutualista
      f.input :emergencia
      f.input :procede #if !f.object.reinscripcion
    end

    f.inputs "Inscripción" do
      f.input :anio, input_html: { value: Config.find(1).anio_inscripciones }
      f.input :proximo_grado_id, :label => 'Grado', :as => :select, :collection => ProximoGrado.where("anio IN (SELECT anio_inscripciones FROM configs WHERE NOT anio_inscripciones IS NULL)").order(:nombre).map{|c| ["#{c.nombre} - $U #{c.precio}", c.id]}
      f.input :formulario_id, :label => 'Formulario', :as => :select, :collection => Formulario.all.map{|c| ["#{c.nombre}", c.id]}
      f.input :convenio_id, :label => 'Convenio', :as => :select, :collection => InscripcionOpcion.where( "inscripcion_opcion_tipo_id IN (SELECT id FROM inscripcion_opcion_tipos WHERE nombre='Convenio' AND NOT id IS NULL)" ).order(:nombre).map{|c| ["#{c.nombre}", c.id]}
      f.input :adicional_id, :label => 'Adicional', :as => :select, :collection => InscripcionOpcion.where( "inscripcion_opcion_tipo_id IN (SELECT id FROM inscripcion_opcion_tipos WHERE nombre='Adicional' AND NOT id IS NULL)" ).order(:nombre).map{|c| ["#{c.nombre}", c.id]}
      f.input :matricula_id, :label => 'Matrícula', :as => :select, :collection => InscripcionOpcion.where( "inscripcion_opcion_tipo_id IN (SELECT id FROM inscripcion_opcion_tipos WHERE nombre='Matrícula' AND NOT id IS NULL)" ).order(:nombre).map{|c| ["#{c.nombre}", c.id]}
      f.input :hermanos_id, :label => 'Hermanos', :as => :select, :collection => InscripcionOpcion.where( "inscripcion_opcion_tipo_id IN (SELECT id FROM inscripcion_opcion_tipos WHERE nombre='Hermanos' AND NOT id IS NULL)" ).order(:nombre).map{|c| ["#{c.nombre}", c.id]}
      f.input :cuotas_id, :label => 'Cuotas', :as => :select, :collection => InscripcionOpcion.where( "inscripcion_opcion_tipo_id IN (SELECT id FROM inscripcion_opcion_tipos WHERE nombre='Cuotas' AND NOT id IS NULL)" ).order(:nombre).map{|c| ["#{c.nombre}", c.id]}
      f.input :precio_anterior
    end
    
    f.inputs "Padre" do
      f.input :nombre_padre
      f.input :apellido_padre
      f.input :cedula_padre
      f.input :lugar_nacimiento_padre
      f.input :fecha_nacimiento_padre
      f.input :email_padre
      f.input :domicilio_padre
      f.input :celular_padre
      f.input :profesion_padre
      f.input :trabajo_padre
      f.input :telefono_trabajo_padre
      f.input :titular_padre
    end

    f.inputs "Madre" do
      f.input :nombre_madre
      f.input :apellido_madre
      f.input :cedula_madre
      f.input :lugar_nacimiento_madre
      f.input :fecha_nacimiento_madre
      f.input :email_madre
      f.input :domicilio_madre
      f.input :celular_madre
      f.input :profesion_madre
      f.input :trabajo_madre
      f.input :telefono_trabajo_madre
      f.input :titular_madre
    end

    f.inputs "Titular 1" do
      f.input :nombre1
      f.input :apellido1
      f.input :documento1
      f.input :domicilio1
      f.input :email1
      f.input :celular1
    end
    f.inputs "Titular 2" do
      f.input :nombre2
      f.input :apellido2
      f.input :documento2
      f.input :domicilio2
      f.input :email2
      f.input :celular2
    end
    f.actions
  end


  controller do

    def create
      p params
      
      if Inscripcion.calc_cedula_digit(params[:inscripcion][:cedula])
        alumno = Alumno.find_or_create_by(cedula: params[:inscripcion][:cedula])
        alumno.nombre = params[:inscripcion][:nombre]
        alumno.apellido = params[:inscripcion][:apellido]
        alumno.lugar_nacimiento = params[:inscripcion][:lugar_nacimiento]
        alumno.fecha_nacimiento = params[:inscripcion][:fecha_nacimiento]
        alumno.domicilio = params[:inscripcion][:domicilio]
        alumno.celular = params[:inscripcion][:celular]
        alumno.mutualista = params[:inscripcion][:mutualista]
        alumno.emergencia = params[:inscripcion][:emergencia]
        alumno.procede = params[:inscripcion][:procede]
        alumno.save!
      end

      create!
    end


    def update
      p params
      p permitted_params

      if Inscripcion.calc_cedula_digit(params[:inscripcion][:cedula])
        alumno = Alumno.find_or_create_by(cedula: params[:inscripcion][:cedula])
        alumno.nombre = params[:inscripcion][:nombre]
        alumno.apellido = params[:inscripcion][:apellido]
        alumno.lugar_nacimiento = params[:inscripcion][:lugar_nacimiento]
        alumno.fecha_nacimiento = params[:inscripcion][:fecha_nacimiento]
        alumno.domicilio = params[:inscripcion][:domicilio]
        alumno.celular = params[:inscripcion][:celular]
        alumno.mutualista = params[:inscripcion][:mutualista]
        alumno.emergencia = params[:inscripcion][:emergencia]
        alumno.procede = params[:inscripcion][:procede]
        alumno.save!
      end

      update!
    end
    
  end

end
