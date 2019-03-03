ActiveAdmin.register Actividad, :as => 'Autorizar' do

  permit_params :nombre, :fecha, :fechainfo,
      actividad_alumno_attributes: [:id,:actividad_id,:alumno_id,:opcion,:fecha,:opcion_secretaria,:fecha_secretaria,:_destroy]

  #menu priority: 3003, label: "Autoriza", parent: "Actividad"

  index do
    #selectable_column
    column :nombre
    column :fecha, label: "Autorización hasta" 
    column :fechainfo, label: "Información hasta" 
    actions
  end

  filter :nombre
  filter :fecha
  filter :fechainfo

  show do |r|
    attributes_table do
      row :nombre
      row :fecha, label: "Autorización hasta" 
      row :fechainfo, label: "Información hasta" 

      row "Alumnos" do 
        table_for ActividadAlumno.where("actividad_id=#{r.id}").order(:id) do |t|
          t.column "Alumno" do |r| (r.alumno != nil ? "#{r.alumno.nombre} #{r.alumno.apellido}" : "") end
          t.column :bajado
          t.column :opcion
          t.column :fecha 
          t.column :opcion_secretaria 
          t.column :fecha_secretaria
        end


        # table_for Alumno.where("id IN (SELECT alumno_id FROM actividad_alumnos WHERE actividad_id=#{r.id}").order(:nombre,:apellido) do |t|
        #   t.column :nombre
        #   t.column :apellido
        #   t.column :bajado
        #   t.column "Opcion Responsable" do |x| ActividadAlumno.find_by(actividad_id: r.id, alumno_id: x.id).opcion end
        #   t.column :fecha
        #   t.column "Opción Secretaría" do |x| ActividadAlumno.find_by(actividad_id: r.id, alumno_id: x.id).opcion_secretaria end
        #   t.column :fecha_secretaria
        # end
      end
    end
  end

  form partial: 'form'

  # form do |f|
  #   f.inputs do
  #     f.input :nombre, input_html: { :readonly => true }
  #     f.input :fecha, label: "Autorización hasta", :as => :date_picker, input_html: { :readonly => true }
  #     f.input :fechainfo, label: "Información hasta", :as => :date_picker, input_html: { :readonly => true }
  #   end

  #   f.inputs do
  #     f.has_many :actividad_alumno, heading: "Alumnos", allow_destroy: false, new_record: false do |l|
  #       l.input :opcion, label: "Opción Responsable", input_html: { :readonly => true }
  #       l.input :fecha, label: "Fecha", input_html: { :readonly => true }
  #       l.input :opcion_secretaria, label: "Opción Secretaría"        
  #       l.input :fecha_secretaria, label: "Fecha"
  #     end
  #   end

  #   f.actions
  # end

end
