ActiveAdmin.register Inscripcion do
  menu priority: 4001, label: 'Inscripción'

  permit_params :fecha, :recibida, :reinscripcion
    :nombre,:apellido,:cedula,:lugar_nacimiento,:fecha_nacimiento,:domicilio,:celular,:mutualista,:emergencia,:procede,
    :proximo_grado_id,:convenio_id,:afinidad,:formulario,:matricula,:hermanos,:cuotas,
    :nombre_padre,:cedula_padre,:lugar_nacimiento_padre,:fecha_nacimiento_padre,:email_padre,:domicilio_padre,:celular_padre,:profesion_padre,:trabajo_padre,:telefono_trabajo_padre,:titular_padre,
    :nombre_madre,:cedula_madre,:lugar_nacimiento_madre,:fecha_nacimiento_madre,:email_madre,:domicilio_madre,:celular_madre,:profesion_madre,:trabajo_madre,:telefono_trabajo_madre,:titular_madre,
    :nombre1,:documento1,:domicilio1,:email1,:celular1,
    :nombre2,:documento2,:domicilio2,:email2,:celular2

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
    actions
  end

  filter :nombre
  filter :apellido
  filter :cedula


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

  form do |f|    
    if f.object.new_record?
      f.input :recibida, input_html: { value: current_admin_usuario.email }, as: :hidden
      f.input :reinscripcion, input_html: { value: :false }, as: :hidden
      f.input :dia, input_html: { value: 10 }, as: :hidden
      f.input :mes, input_html: { value: 1 }, as: :hidden
      f.input :anio, input_html: { value: 2019 }, as: :hidden
    end

    f.inputs "Alumno" do
      f.input :nombre, label: "Nombre"
      f.input :apellido, label: "Apellido"
      f.input :cedula, label: "Cédula"
      f.input :lugar_nacimiento, label: 'Lugar de nacimiento'
      f.input :fecha_nacimiento, label: 'Fecha de nacimiento'
      f.input :domicilio, label: 'Domicilio'
      f.input :celular, label: 'Teléfono/Celular'
      f.input :mutualista, label: 'Mutualista'
      f.input :emergencia, label: 'Emergencia'
      f.input :procede, label: 'Procede de'
    end

    f.inputs "Nivel" do
      f.input :proximo_grado_id, :label => 'Grado', :as => :select, :collection => ProximoGrado.all.order(:nombre).map{|c| ["#{c.nombre} - $U #{c.precio}", c.id]}
      f.input :convenio_id, :label => 'Convenio', :as => :select, :collection => Convenio.all.order(:nombre).map{|c| ["#{c.nombre} - #{c.valor}%", c.id]}
      f.input :formulario, :label => 'Formulario', :as => :select, :collection => Convenio.where("formulario").order(:valor).map{|c| ["#{c.nombre} - #{c.valor}%", c.id]}
      f.input :afinidad
      f.input :matricula, :label => 'Matrícula', :as => :select, :collection => [["Contado",5],["Exonerada",6]]
      f.input :hermanos, :label => 'Hermanos', :as => :select, :collection => [["Sin hermanos",0],["1 hermano - 5%",1],["2 hermanos - 10%",2]] 
      f.input :cuotas
      f.input :especial
    end
    
    f.inputs "Padre" do
      f.input :nombre_padre, label: 'Nombre'
      f.input :cedula_padre, label: 'Cédula'
      f.input :lugar_nacimiento_padre, label: 'Lugar de nacimiento'
      f.input :fecha_nacimiento_padre, label: 'Fecha de nacimiento'
      f.input :email_padre, label: 'Mail'
      f.input :domicilio_padre, label: 'Domicilio'
      f.input :celular_padre, label: 'Teléfono/Celular'
      f.input :profesion_padre, label: 'Profesión'
      f.input :trabajo_padre, label: 'Lugar de Trabajo'
      f.input :telefono_trabajo_padre, label: 'Teléfono de Trabajo'
      f.input :titular_padre, label: 'Titular'
    end

    f.inputs "Madre" do
      f.input :nombre_madre, label: 'Nombre'
      f.input :cedula_madre, label: 'Cédula'
      f.input :lugar_nacimiento_madre, label: 'Lugar de nacimiento'
      f.input :fecha_nacimiento_madre, label: 'Fecha de nacimiento'
      f.input :email_madre, label: 'Mail'
      f.input :domicilio_madre, label: 'Domicilio'
      f.input :celular_madre, label: 'Teléfono/Celular'
      f.input :profesion_madre, label: 'Profesión'
      f.input :trabajo_madre, label: 'Lugar de Trabajo'
      f.input :telefono_trabajo_madre, label: 'Teléfono de Trabajo'
      f.input :titular_madre, label: 'Titular'
    end

    f.inputs "Titular 1" do
      f.input :nombre1, label: "Nombre"
      f.input :documento1, label: "Cédula"
      f.input :domicilio1, label: "Domicilio"
      f.input :email1, label: "Mail"
      f.input :celular1, label: "Teléfono/Celular"
    end
    f.inputs "Titular 2" do
      f.input :nombre2, label: "Nombre"
      f.input :documento2, label: "Cédula"
      f.input :domicilio2, label: "Domicilio"
      f.input :email2, label: "Mail"
      f.input :celular2, label: "Teléfono/Celular"
    end
    f.actions
  end
end
