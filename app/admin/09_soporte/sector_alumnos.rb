ActiveAdmin.register SectorAlumno do

  permit_params :id, :nombre

  menu priority: 906, label: "Alumnos por Sector", parent: "Soporte"

  index do
  	#selectable_column
    column :sector_id
    column "Alumno" do |c| (c.alumno != nil ? "#{c.alumno.nombre} #{c.alumno.apellido}" : "" ) end
    actions
  end

  show do
    attributes_table do
      row :sector_id
      row "Alumno" do |c| (c.alumno != nil ? "#{c.alumno.nombre} #{c.alumno.apellido}" : "" ) end
    end
  end

  form do |f| 
    f.inputs "Alumnos por Sector" do
      f.input :sector_id
      f.input :alumno, :as => :select, :collection => Alumno.all.order(:nombre,:apellido).map{|u| ["#{u.nombre} #{u.apellido}",u.id]}
    end
    f.actions
  end

end