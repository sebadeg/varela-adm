ActiveAdmin.register Actividad, :as => 'Autorizaciones' do

  permit_params :nombre, :fecha, :fechainfo,
      actividad_alumno_attributes: [:id,:actividad_id,:lista_id,:_destroy]

  menu priority: 3003, label: "Autorizaciones", parent: "Actividad"

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
        # table_for ActividadAlumno.where("actividad_id=#{r.id})").order(:id) do |t|
        #   t.column "Alumno" do |r| (r.alumno != nil ? "#{r.alumno.id} - #{r.alumno.nombre} #{r.alumno.apellido}" : "") end
        #   t.column :opcion
        #   t.column :fecha 
        #   t.column :secretaria 
        #   t.column :mail
        # end


        table_for Alumno.where("id IN (SELECT alumno_id FROM actividad_alumnos WHERE actividad_id=#{r.id})").order(:nombre,:apellido) do |t|
          t.column :nombre
          t.column :apellido
          t.column "Opcion" do |x| ActividadAlumno.find_by(actividad_id: r.id, alumno_id: x.id).opcion end
          t.column "Fecha" do |x| ActividadAlumno.find_by(actividad_id: r.id, alumno_id: x.id).fecha end
          t.column "Secretaría" do |x| ActividadAlumno.find_by(actividad_id: r.id, alumno_id: x.id).secretaria end
          t.column "Mail" do |x| ActividadAlumno.find_by(actividad_id: r.id, alumno_id: x.id).mail end
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :nombre
      f.input :fecha, label: "Autorización hasta", :as => :date_picker
      f.input :fechainfo, label: "Información hasta", :as => :date_picker
    end

    f.inputs do
      f.has_many :actividad_opcion, heading: "Alumnos", allow_destroy: true, new_record: true do |l|
        l.label l.object.nombre
        l.input l.object.apellido
      # t.column "Opcion" do |x| ActividadAlumno.find_by(actividad_id: r.id, alumno_id: x.id).opcion end
      # t.column "Fecha" do |x| ActividadAlumno.find_by(actividad_id: r.id, alumno_id: x.id).fecha end
      # t.column "Secretaría" do |x| ActividadAlumno.find_by(actividad_id: r.id, alumno_id: x.id).secretaria end
      # t.column "Mail" do |x| ActividadAlumno.find_by(actividad_id: r.id, alumno_id: x.id).mail end
      end
    end

    f.actions
  end

end
