ActiveAdmin.register Inscripcion2020 do

  menu priority: 601, label: "Inscripciones", parent: "Inscripciones"

  permit_params :created_at, :alumno_id, :padre_id, :padre_titular, :madre_id, :madre_titular, :titular1_id, :titular1_id,
        :proximo_grado_id,
        :formulario2020_id, :convenio2020_id, :afinidad2020_id, :adicional, :congelado, :hermanos2020_id, 
        :cuota2020_id, :matricula2020_id

  scope :inscripcion
  scope :reinscripcion

  index do
  	#selectable_column
    column "Alumno" do |r| (r.alumno == nil ? "" : r.alumno.toString()) end      
    column "Modificado" do |r| r.updated_at == nil ? "" : I18n.l(r.updated_at, format: '%d/%m/%Y %H:%M:%S') end

    actions
  end

  filter :alumno_id, :label => 'Código' 
  filter :alumno_id, :label => 'Cédula', :as => :select, :collection => Alumno.all.order(:cedula).map{|u| [u.toString(), u.id]}

  show do
    attributes_table title:"Datos" do
      row "Alumno" do |r| (r.alumno != nil ? r.alumno.toString() : "") end
      row "Padre" do |r| (r.padre != nil ? r.padre.toString() : "") end
      row "Padre Titular" do |r| r.padre_titular end
      row "Madre" do |r| (r.madre != nil ? r.madre.toString() : "") end
      row "Madre Titular" do |r| r.madre_titular end
      row "Titular 1" do |r| (r.titular1 != nil ? r.titular1.toString() : "") end
      row "Titular 2" do |r| (r.titular2 != nil ? r.titular2.toString() : "") end
      row "Grado" do |r| (r.proximo_grado != nil ? r.proximo_grado.toString() : "") end
    end
    attributes_table title:"Forma de pago" do
      row "Formulario" do |r| (r.formulario2020 != nil ? r.formulario2020.toString() : "") end
      row "Convenio" do |r| (r.convenio2020 != nil ? r.convenio2020.toString() : "") end
      row "Afinidad" do |r| (r.afinidad2020 != nil ? r.afinidad2020.toString() : "") end
      row "Congelado" do |r| "#{r.congelado}" end    
      row "Adicional" do |r| "#{r.adicional}" end
      row "Hermanos" do |r| (r.hermanos2020 != nil ? r.hermanos2020.toString() : "") end
      row "Cuota" do |r| (r.cuota2020 != nil ? r.cuota2020.toString() : "") end
      row "Matricula" do |r| (r.matricula2020 != nil ? r.matricula2020.toString() : "") end
    end
    attributes_table title:"Proceso" do
      row "Registrado" do |r| r.fecha_registrado end
      row "Vale generado" do |r| r.fecha_vale end
      row "Vale descargado" do |r| r.fecha_descargado end
      row "Vale entregado" do |r| r.fecha_entregado end
      row "Inscripto" do |r| r.fecha_inscripto end
    end 
  end

  form do |f|  

    def consultaFecha()
      return "fecha_comienzo<='#{DateTime.now.strftime("%Y-%m-%d")}' AND (fecha_fin IS NULL OR fecha_fin>='#{DateTime.now.strftime("%Y-%m-%d")}')"
    end

    f.inputs do
      if f.object.new_record?
        #f.input :recibida, input_html: { value: current_admin_usuario.email }, as: :hidden
        f.input :reinscripcion, input_html: { value: false }, as: :hidden
        f.input :anio, input_html: { value: 2021 }
      end
      f.input :alumno, :label => 'Alumno', :as => :select, :collection => Alumno.order(:cedula).map{|c| [c.toString(), c.id]}
      f.input :padre, :label => 'Padre', :as => :select, :collection => Usuario.order(:cedula).map{|c| [c.toString(), c.id]}
      f.input :padre_titular, :label => 'Padre Titular'
      f.input :madre, :label => 'Madre', :as => :select, :collection => Usuario.order(:cedula).map{|c| [c.toString(), c.id]}
      f.input :madre_titular, :label => 'Madre Titular'
      f.input :titular1, :label => 'Titular 1', :as => :select, :collection => Usuario.order(:cedula).map{|c| [c.toString(), c.id]}
      f.input :titular2, :label => 'Titular 2', :as => :select, :collection => Usuario.order(:cedula).map{|c| [c.toString(), c.id]}
      f.input :proximo_grado, :label => 'Grado', :as => :select, :collection => ProximoGrado.where("anio=2021").order(:nombre).map{|c| [c.toString(), c.id]}
    end
    f.inputs do
      f.input :formulario2020, :label => 'Formulario', :as => :select, :collection => Formulario2020.where(consultaFecha()).order(:nombre).map{|c| [c.toString(), c.id]}
      f.input :convenio2020, :label => 'Convenio', :as => :select, :collection => Convenio2020.where(consultaFecha()).order(:nombre).map{|c| [c.toString(), c.id]}
      f.input :afinidad2020, :label => 'Afinidad', :as => :select, :collection => Afinidad2020.where(consultaFecha()).order(:nombre).map{|c| [c.toString(), c.id]}
      f.input :congelado
      f.input :adicional
      f.input :hermanos2020, :label => 'Hermanos', :as => :select, :collection => Hermanos2020.where(consultaFecha()).order(:nombre).map{|c| [c.toString(), c.id]}
      f.input :cuota2020, :label => 'Cuotas', :as => :select, :collection => Cuota2020.where(consultaFecha()).order(:nombre).map{|c| [c.toString(), c.id]}
      f.input :matricula2020, :label => 'Matrícula', :as => :select, :collection => Matricula2020.where(consultaFecha()).order(:nombre).map{|c| [c.toString(), c.id]}
      f.input :fecha_registrado, :label => 'Registrado', input_html: {disabled: :true}
      f.input :fecha_vale, :label => 'Vale generado', input_html: {disabled: :true}
      f.input :fecha_descargado, :label => 'Vale descargado', input_html: {disabled: :true}
      f.input :fecha_entregado, :label => 'Vale entregado', input_html: {disabled: :true}
      f.input :fecha_inscripto, :label => 'Inscripto', input_html: {disabled: :true}

    end
    f.actions
  end

end
