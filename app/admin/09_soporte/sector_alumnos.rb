ActiveAdmin.register SectorAlumno do
  permit_params :id, :sector_id, :alumno_id

  menu priority: 906, label: "Alumnos por Sector", parent: "Soporte"

  index do
  	#selectable_column
    column "Sector" do |c| (c.sector != nil ? "#{c.sector.nombre}" : "" ) end
    column "Alumno" do |c| (c.alumno != nil ? "#{u.id} - #{c.alumno.nombre} #{c.alumno.apellido}" : "" ) end
    column :anio
    actions
  end

  show do
    attributes_table do
      row "Sector" do |c| (c.sector != nil ? "#{c.sector.nombre}" : "" ) end
      row "Alumno" do |c| (c.alumno != nil ? "#{u.id} - #{c.alumno.nombre} #{c.alumno.apellido}" : "" ) end
      row :anio
    end
  end

  filter :sector_id, :label => 'Sector', :as => :select, :collection => Sector.all.order(:nombre).map{|u| ["#{u.nombre}",u.id]}
  filter :alumno_id, :label => 'Alumno', :as => :select, :collection => Alumno.all.order(:nombre,:apellido).map{|u| ["#{u.id} - #{u.nombre} #{u.apellido}", u.id]}
  filter :anio

  form do |f| 
    f.inputs "Alumnos por Sector" do
      f.input :sector, :as => :select, :collection => Sector.all.order(:nombre).map{|u| ["#{u.nombre}",u.id]}
      f.input :alumno, :as => :select, :collection => Alumno.all.order(:nombre,:apellido).map{|u| ["#{u.id} - #{u.nombre} #{u.apellido}", u.id]}
      f.input :anio
    end
    f.actions
  end

end