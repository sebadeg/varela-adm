ActiveAdmin.register SectorAlumno do
  permit_params :id, :sector_id, :alumno_id

  menu priority: 906, label: "Alumnos por Sector", parent: "Soporte"

  index do
  	#selectable_column
    column "Sector" do |c| (c.sector != nil ? "#{c.sector.nombre}" : "" ) end
    column "Alumno" do |c| (c.alumno != nil ? "#{c.alumno.nombre} #{c.alumno.apellido}" : "" ) end
    actions
  end

  show do
    attributes_table do
      row "Sector" do |c| (c.sector != nil ? "#{c.sector.nombre}" : "" ) end
      row "Alumno" do |c| (c.alumno != nil ? "#{c.alumno.nombre} #{c.alumno.apellido}" : "" ) end
    end
  end

  form do |f| 
    f.inputs "Alumnos por Sector" do
      f.input :sector, :as => :select, :collection => Sector.all.order(:nombre).map{|u| ["#{u.nombre}",u.id]}
      f.input :alumno, :as => :select, :collection => Alumno.all.order(:nombre,:apellido).map{|u| ["#{u.nombre} #{u.apellido}",u.id]}
    end
    f.actions
  end

end