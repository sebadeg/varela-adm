ActiveAdmin.register Inscripcion2020 do

  menu priority: 600, label: "Inscripciones 2020", parent: "Inscripciones"

  permit_params :created_at, :alumno_id, :padre_id, :madre_id, :titular1_id, :titular1_id,  
        :convenio2020, :matricula2020, :hermanos2020, :cuota2020

  index do
  	#selectable_column
    column "Alumno" do |r| (r.alumno == nil ? "" : r.alumno.toString()) end      
    column "Modificado" do |r| r.updated_at == nil ? "" : I18n.l(r.updated_at, format: '%d/%m/%Y %H:%M:%S') end

    actions
  end

  filter :alumno_id

  show do
    attributes_table title:"Datos" do
      row "Alumno" do |r| (r.alumno != nil ? r.alumno.toString() : "") end
      row "Padre" do |r| (r.padre != nil ? r.padre.toString() : "") end
      row "Madre" do |r| (r.madre != nil ? r.madre.toString() : "") end
      row "Titular 1" do |r| (r.titular1 != nil ? r.titular1.toString() : "") end
      row "Titular 2" do |r| (r.titular2 != nil ? r.titular2.toString() : "") end
      row "Grado" do |r| (r.proximo_grado != nil ? r.proximo_grado.toString() : "") end
    end
    attributes_table title:"Forma de pago" do
      row "Convenio" do |r| (r.convenio2020 != nil ? r.convenio2020.toString() : "") end
      row "Adicional" do |r| "#{r.adicional}" end    
      row "Afinidad" do |r| (r.afinidad2020 != nil ? r.afinidad2020.toString() : "") end
    end 
  end

  form do |f|    
    f.inputs do
      if f.object.new_record?
        #f.input :recibida, input_html: { value: current_admin_usuario.email }, as: :hidden
        f.input :reinscripcion, input_html: { value: false }, as: :hidden
      end

      f.input :alumno, :label => 'Alumno', :as => :select, :collection => Alumno.order(:cedula).map{|c| [c.toString(), c.id]}
      f.input :padre, :label => 'Padre', :as => :select, :collection => Usuario.order(:cedula).map{|c| [c.toString(), c.id]}
      f.input :madre, :label => 'Madre', :as => :select, :collection => Usuario.order(:cedula).map{|c| [c.toString(), c.id]}
      f.input :titular1, :label => 'Titular 1', :as => :select, :collection => Usuario.order(:cedula).map{|c| [c.toString(), c.id]}
      f.input :titular2, :label => 'Titular 2', :as => :select, :collection => Usuario.order(:cedula).map{|c| [c.toString(), c.id]}
      f.input :proximo_grado, :label => 'Grado', :as => :select, :collection => ProximoGrado.where("anio=2021").order(:nombre).map{|c| [c.toString(), c.id]}
    end
    f.inputs do
      f.input :convenio2020, :label => 'Convenio', :as => :select, :collection => Convenio2020.order(:nombre).map{|c| [c.toString(), c.id]}
      f.input :adicional
      f.input :afinidad2020, :label => 'Afinidad', :as => :select, :collection => Afinidad2020.order(:nombre).map{|c| [c.toString(), c.id]}
    end
    f.actions
  end

end
