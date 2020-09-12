ActiveAdmin.register Inscripcion2020 do

  menu priority: 601, label: "Inscripciones", parent: "Inscripciones"

  permit_params :created_at, :alumno_id, :padre_id, :padre_titular, :madre_id, :madre_titular, :titular1_id, :titular1_id,
        :proximo_grado_id,
        :formulario2020_id, :convenio2020_id, :afinidad2020_id, :adicional, :fija, :congelado, :hermanos2020_id, 
        :cuota2020_id, :matricula2020_id,
        :fecha_registrado, :fecha_vale, :fecha_descargado, :fecha_inscripto, 
        :fecha_comienzo, :fecha_primera, :fecha_ultima, :fecha_fin



  scope :inscripcion
  scope :reinscripcion



  action_item :habilitar, only: :show do
    if inscripcion2020.inhabilitado
      link_to "Habilitar", habilitar_admin_inscripcion2020_path(inscripcion2020), method: :put 
    else
      link_to "Inhabilitar", habilitar_admin_inscripcion2020_path(inscripcion2020), method: :put   
    end
  end

  member_action :habilitar, method: :put do
    id = params[:id]

    inscripcion2020 = Inscripcion2020.find(id)
    inscripcion2020.inhabilitado = !inscripcion2020.inhabilitado;
    inscripcion2020.save!

    redirect_to admin_inscripcion2020_path(inscripcion2020)
  end





  action_item :registrar, only: :show do
    if inscripcion2020.fecha_registrado != nil
      link_to "Desregistrar", registrar_admin_inscripcion2020_path(inscripcion2020), method: :put   
    else
      link_to "Registrar", registrar_admin_inscripcion2020_path(inscripcion2020), method: :put 
    end
  end

  member_action :registrar, method: :put do
    id = params[:id]
    inscripcion2020 = Inscripcion2020.find(id)
    if inscripcion2020.fecha_registrado == nil
      inscripcion2020.fecha_registrado = DateTime.now
    else
      inscripcion2020.fecha_registrado = nil
    end
    inscripcion2020.save!
    redirect_to admin_inscripcion2020_path(inscripcion2020)
  end





  action_item :generar_vale, only: :show do
    if inscripcion2020.fecha_vale != nil
      link_to "Quitar vale", generar_vale_admin_inscripcion2020_path(inscripcion2020), method: :put   
    else
      link_to "Generar vale", generar_vale_admin_inscripcion2020_path(inscripcion2020), method: :put 
    end
  end

 member_action :generar_vale, method: :put do
    id = params[:id]
    inscripcion2020 = Inscripcion2020.find(id)
    if inscripcion2020.fecha_vale == nil
      inscripcion2020.fecha_vale = DateTime.now

      TitularCuenta.where("cuenta_id=#{inscripcion2020.cuenta_id}").each do |titular_cuenta|
        usuario = Usuario.find(titular_cuenta.usuario_id)
        UserMailer.hay_vale_usuario(usuario).deliver_now
      end

    else
      inscripcion2020.fecha_vale = nil
    end
    inscripcion2020.save!

    redirect_to admin_inscripcion2020_path(inscripcion2020)
  end




  action_item :inscribir, only: :show do
    if inscripcion2020.fecha_inscripto != nil
      link_to "Desinscribir", inscribir_admin_inscripcion2020_path(inscripcion2020), method: :put 
    else
      link_to "Inscribir", inscribir_admin_inscripcion2020_path(inscripcion2020), method: :put 
    end
  end

  member_action :inscribir, method: :put do
    id = params[:id]
    inscripcion2020 = Inscripcion2020.find(id)
    if inscripcion2020.fecha_inscripto == nil
      inscripcion2020.fecha_inscripto = DateTime.now
    else
      inscripcion2020.fecha_inscripto = nil
    end
    inscripcion2020.save!
    
    redirect_to admin_inscripcion2020_path(inscripcion2020)
  end



action_item :formulario, only: :show do
    link_to "Formulario y Vale", formulario_admin_inscripcion2020_path(inscripcion2020), method: :put 
  end

  member_action :formulario, method: :put do
    id = params[:id]
    inscripcion2020 = Inscripcion2020.find(id)
    alumno = Alumno.find(inscripcion2020.alumno_id)
  
    file_name = "Inscripcion #{alumno.nombre} #{alumno.apellido}.pdf"
    file = Tempfile.new(file_name)
    inscripcion2020.vale(file.path)

    send_file(
        file.path,
        filename: file_name,
        type: "application/pdf"
      )
    
  end





  index do
  	#selectable_column
    column "Alumno" do |r| (r.alumno == nil ? "" : r.alumno.toString()) end      
    column "Modificado" do |r| r.updated_at == nil ? "" : I18n.l(r.updated_at, format: '%d/%m/%Y %H:%M:%S') end

    actions
  end

  filter :alumno_id, :label => 'Código' 
  filter :alumno_id, :label => 'Cédula', :as => :select, :collection => Alumno.all.order(:cedula).map{|u| [u.toString(), u.id]}

  show do

    attributes_table title:"Inscripción" do
      row "Fecha" do |r| I18n.l(r.created_at, format: '%-d de %B de %Y') end
      row :recibida
      row "Año" do |r| (r.anio) end
      row :fecha_comienzo
      row :fecha_primera
      row :fecha_ultima
      row :fecha_fin
      row "Código cuenta" do |r| (r.cuenta_id) end
      row "Código alumno" do |r| (r.nuevo_alumno_id) end
    end
    attributes_table title:"Datos" do
      row "Alumno" do |r| (r.alumno != nil ? r.alumno.toString() : "") end
      row "Padre" do |r| (r.padre != nil ? r.padre.toString() : "") end
      row "Padre Titular" do |r| r.padre_titular end
      row "Madre" do |r| (r.madre != nil ? r.madre.toString() : "") end
      row "Madre Titular" do |r| r.madre_titular end
      row "Titular 1" do |r| (r.titular1 != nil ? r.titular1.toString() : "") end
      row "Titular 2" do |r| (r.titular2 != nil ? r.titular2.toString() : "") end
      row "Nivel" do |r| (r.grado != nil ? r.grado.toString() : "") end
      row "Grado" do |r| (r.proximo_grado != nil ? r.proximo_grado.toString() : "") end
    end
    attributes_table title:"Forma de pago" do
      row "Formulario" do |r| (r.formulario2020 != nil ? r.formulario2020.toString() : "") end
      row "Convenio" do |r| (r.convenio2020 != nil ? r.convenio2020.toString() : "") end
      row "Afinidad" do |r| (r.afinidad2020 != nil ? r.afinidad2020.toString() : "") end
      row "Congelado" do |r| "#{Common.decimal_to_string(r.congelado,2)}%" end    
      row "Adicional" do |r| "#{Common.decimal_to_string(r.adicional,2)}%" end
      row "Fija" do |r| "#{r.fija}" end
      row "Hermanos" do |r| (r.hermanos2020 != nil ? r.hermanos2020.toString() : "") end
      row "Cuota" do |r| (r.cuota2020 != nil ? r.cuota2020.toString() : "") end
      row "Matricula" do |r| (r.matricula2020 != nil ? r.matricula2020.toString() : "") end
      row "Precio" do |r| r.CalcularPrecioToStr() end
      row "Movimientos" do |r| r.CalcularMovimientosToStr() end
    end
    attributes_table title:"Proceso" do
      row "Registrado" do |r| r.fecha_registrado end
      row "Vale generado" do |r| r.fecha_vale end
      row "Vale descargado" do |r| r.fecha_descargado end
      row "Inscripto" do |r| r.fecha_inscripto end
    end 
  end

  form do |f|  

    def consultaFecha()
      return "fecha_comienzo<='#{DateTime.now.strftime("%Y-%m-%d")}' AND (fecha_fin IS NULL OR fecha_fin>='#{DateTime.now.strftime("%Y-%m-%d")}')"
    end

    f.inputs do
      if f.object.new_record?
        f.input :recibida, input_html: { value: current_admin_usuario.email }, as: :hidden
        f.input :reinscripcion, input_html: { value: false }
      end
      f.input :fecha_comienzo
      f.input :fecha_primera
      f.input :fecha_ultima
      f.input :fecha_fin
      f.input :cuenta_id #, label => 'Código cuenta'
      f.input :nuevo_alumno_id #, label => 'Código alumno'
    end
    f.inputs do
      f.input :alumno, :label => 'Alumno', :as => :select, :collection => Alumno.order(:cedula).map{|c| [c.toString(), c.id]}
      f.input :padre, :label => 'Padre', :as => :select, :collection => Usuario.order(:cedula).map{|c| [c.toString(), c.id]}
      f.input :padre_titular, :label => 'Padre Titular'
      f.input :madre, :label => 'Madre', :as => :select, :collection => Usuario.order(:cedula).map{|c| [c.toString(), c.id]}
      f.input :madre_titular, :label => 'Madre Titular'
      f.input :titular1, :label => 'Titular 1', :as => :select, :collection => Usuario.order(:cedula).map{|c| [c.toString(), c.id]}
      f.input :titular2, :label => 'Titular 2', :as => :select, :collection => Usuario.order(:cedula).map{|c| [c.toString(), c.id]}
      f.input :grado, :label => 'Nivel', :as => :select, :collection => Grado.all.order(:nombre).map{|c| [c.toString(), c.id]}
      f.input :proximo_grado, :label => 'Grado', :as => :select, :collection => ProximoGrado.where("anio=2021").order(:nombre).map{|c| [c.toString(), c.id]}
      f.input :anio, :label => 'Año'
    end
    f.inputs do
      f.input :formulario2020, :label => 'Formulario', :as => :select, :collection => Formulario2020.order(:nombre).map{|c| [c.toString(), c.id]}
      f.input :convenio2020, :label => 'Convenio', :as => :select, :collection => Convenio2020.order(:nombre).map{|c| [c.toString(), c.id]}
      f.input :afinidad2020, :label => 'Afinidad', :as => :select, :collection => Afinidad2020.order(:nombre).map{|c| [c.toString(), c.id]}
      f.input :congelado
      f.input :adicional
      f.input :fija
      f.input :hermanos2020, :label => 'Hermanos', :as => :select, :collection => Hermanos2020.order(:nombre).map{|c| [c.toString(), c.id]}
      f.input :cuota2020, :label => 'Cuotas', :as => :select, :collection => Cuota2020.order(:nombre).map{|c| [c.toString(), c.id]}
      f.input :matricula2020, :label => 'Matrícula', :as => :select, :collection => Matricula2020.order(:nombre).map{|c| [c.toString(), c.id]}
      f.input :fecha_registrado, :label => 'Registrado', input_html: {disabled: :true}
      f.input :fecha_vale, :label => 'Vale generado', input_html: {disabled: :true}
      f.input :fecha_descargado, :label => 'Vale descargado', input_html: {disabled: :true}
      f.input :fecha_inscripto, :label => 'Inscripto', input_html: {disabled: :true}

    end
    f.actions
  end

end
