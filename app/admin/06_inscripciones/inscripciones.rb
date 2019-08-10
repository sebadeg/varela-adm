ActiveAdmin.register Inscripcion do

  menu priority: 601, label: "Inscripciones", parent: "Inscripciones"

  permit_params :fecha, :recibida, :reinscripcion, :anio, 
    :nombre,:apellido,:cedula,:lugar_nacimiento,:fecha_nacimiento,:domicilio,:celular,:mutualista,:emergencia,:procede,
    :proximo_grado_id,:convenio_id,:afinidad,:formulario,:matricula,:hermanos,:cuotas,
    :nombre_padre,:cedula_padre,:lugar_nacimiento_padre,:fecha_nacimiento_padre,:email_padre,:domicilio_padre,:celular_padre,:profesion_padre,:trabajo_padre,:telefono_trabajo_padre,:titular_padre,
    :nombre_madre,:cedula_madre,:lugar_nacimiento_madre,:fecha_nacimiento_madre,:email_madre,:domicilio_madre,:celular_madre,:profesion_madre,:trabajo_madre,:telefono_trabajo_madre,:titular_madre,
    :nombre1,:documento1,:domicilio1,:email1,:celular1,
    :nombre2,:documento2,:domicilio2,:email2,:celular2

  scope :todos
  scope :inscripciones
  scope :reinscripciones

  action_item :formulario, only: :show do
    link_to "Formulario y Vale", formulario_admin_inscripcion_path(inscripcion), method: :put 
  end

  member_action :formulario, method: :put do
    id = params[:id]
    inscripcion = Inscripcion.find(id)
  
    file_name = "Inscripcion #{inscripcion.nombre} #{inscripcion.apellido}.pdf"
    file = Tempfile.new(file_name)
    inscripcion.imprimir_formulario(file.path)

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
    column :anio
    actions
  end

  filter :nombre
  filter :apellido
  filter :cedula
  filter :reinscripcion
  filter :anio


  show do

    def find(arr,v)
      arr.each do |a|
        if a[1]==v
          return a[0]
        end
      end
      return ""
    end

    attributes_table title:"Inscripcion" do
      row "Fecha" do |r| I18n.l(r.created_at, format: '%-d de %B de %Y') end
      row :anio
      row :recibida
    end

    attributes_table title:"Alumno" do
      row :nombre
      row :apellido
      row 'Cédula' do |r| r.cedula end
      row 'Lugar de nacimiento' do |r| r.lugar_nacimiento end
      row 'Fecha de nacimiento' do |r| r.fecha_nacimiento end
      row :domicilio
      row 'Teléfono/Celular' do |r| r.celular end
      row :mutualista
      row :emergencia
      row :procede
    end

    attributes_table title:"Nivel" do
      row "Grado" do |r| (r.proximo_grado != nil ? "#{r.proximo_grado.nombre} - $U #{r.proximo_grado.precio}" : "") end      
      row "Convenio" do |r| (r.convenio != nil ? "#{r.convenio.nombre} - #{r.convenio.valor}%" : "") end
      row "Formulario" do |r| ( (formulario = Convenio.find(r.formulario)) != nil ? "#{formulario.nombre} - #{formulario.valor}%" : "") end
      row :afinidad
      row "Matrícula" do |r| find([["Contado",5],["Exonerada",6]],r.matricula) end
      row "Hermanos" do |r| find([["Sin hermanos",0],["1 hermano - 5%",1],["2 hermanos - 10%",2]],r.hermanos) end
      row :cuotas
      row :especial
    end

    attributes_table title:"Padre" do
      row 'Nombre' do |r| r.nombre_padre end
      row 'Cédula' do |r| r.cedula_padre end
      row 'Lugar de nacimiento' do |r| r.lugar_nacimiento_padre end
      row 'Fecha de nacimiento' do |r| r.fecha_nacimiento_padre end
      row 'Mail' do |r| r.email_padre end
      row 'Domicilio' do |r| r.domicilio_padre end
      row 'Teléfono/Celular' do |r| r.celular_padre end
      row 'Profesión' do |r| r.profesion_padre end
      row 'Trabajo' do |r| r.trabajo_padre end
      row 'Teléfono trabajo' do |r| r.telefono_trabajo_padre end
      row 'Titular' do |r| r.titular_padre end
    end

    attributes_table title:"Madre" do
      row 'Nombre' do |r| r.nombre_madre end
      row 'Cédula' do |r| r.cedula_madre end
      row 'Lugar de nacimiento' do |r| r.lugar_nacimiento_madre end
      row 'Fecha de nacimiento' do |r| r.fecha_nacimiento_madre end
      row 'Mail' do |r| r.email_madre end
      row 'Domicilio' do |r| r.domicilio_madre end
      row 'Teléfono/Celular' do |r| r.celular_madre end
      row 'Profesión' do |r| r.profesion_madre end
      row 'Trabajo' do |r| r.trabajo_madre end
      row 'Teléfono trabajo' do |r| r.telefono_trabajo_madre end
      row 'Titular' do |r| r.titular_madre end
    end

    attributes_table title:"Titular 1" do
      row 'Nombre' do |r| r.nombre1 end
      row 'Cédula' do |r| r.documento1 end
      row 'Domicilio' do |r| r.domicilio1 end
      row 'Mail' do |r| r.email1 end
      row 'Teléfono/Celular' do |r| r.celular1 end
    end

    attributes_table title:"Titular 2" do
      row 'Nombre' do |r| r.nombre2 end
      row 'Cédula' do |r| r.documento2 end
      row 'Domicilio' do |r| r.domicilio2 end
      row 'Mail' do |r| r.email2 end
      row 'Teléfono/Celular' do |r| r.celular2 end
    end
  end

  form partial: 'form'

  controller do

    def create
      attrs = params[:inscripcion] #permitted_params[:inscripcion]

      titulares = Array.new()

      if attrs[:titular1][:id] !=nil && attrs[:titular1][:id] != ""
        titulares.push(attrs[:titular1][:id])
      end
      if attrs[:titular2][:id] != nil && attrs[:titular2][:id] != ""
        titulares.push(attrs[:titular2][:id])
      end
      if attrs[:titular_padre] == "1" && attrs[:padre][:id] != nil && attrs[:padre][:id] != ""
        titulares.push(attrs[:padre][:id])
      end
      if attrs[:titular_madre] == "1" && attrs[:madre][:id] != nil && attrs[:madre][:id] != ""
        titulares.push(attrs[:madre][:id])
      end

      if titulares.length <= 0 || titulares.length > 2
        p "**************************************************************"
        p "**************************************************************"
        p "Error"
        p "**************************************************************"
        p "**************************************************************"
        return
      end

      attrs[:documento1] = titulares[0]
      if titulares.length > 1
        attrs[:documento2] = titulares[1]
      end

      p "**************************************************************"
      p "**************************************************************"
      p attrs
      p "**************************************************************"
      p "**************************************************************"


      #create!
    end

    def update
      attrs = permitted_params[:inscripcion]
      p attrs

      #update!
    end
    
  end

end
