ActiveAdmin.register Aactividad, :as => 'Autorizaciones' do

  permit_params :nombre, :fecha, :fechainfo,
      aactividad_alumno_attributes: [:id,:aactividad_id,:lista_id,:_destroy]

  menu priority: 3003, label: "Autorizaciones"
  menu parent: "Actividad 2019", priority: 3000

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
        # table_for AactividadAlumno.where("aactividad_id=#{r.id})").order(:id) do |t|
        #   t.column "Alumno" do |r| (r.alumno != nil ? "#{r.alumno.id} - #{r.alumno.nombre} #{r.alumno.apellido}" : "") end
        #   t.column :opcion
        #   t.column :fecha 
        #   t.column :secretaria 
        #   t.column :mail
        # end


        table_for Alumno.where("id IN (SELECT alumno_id FROM aactividad_alumnos WHERE aactividad_id=#{r.id})").order(:nombre,:apellido) do |t|
          t.column :nombre
          t.column :apellido
          t.column "Opcion" do |x| AactividadAlumno.find_by(aactividad_id: r.id, alumno_id: x.id).opcion end
          t.column "Fecha" do |x| AactividadAlumno.find_by(aactividad_id: r.id, alumno_id: x.id).fecha end
          t.column "Secretaría" do |x| AactividadAlumno.find_by(aactividad_id: r.id, alumno_id: x.id).secretaria end
          t.column "Mail" do |x| AactividadAlumno.find_by(aactividad_id: r.id, alumno_id: x.id).mail end
        end
      end
    end
  end

end
