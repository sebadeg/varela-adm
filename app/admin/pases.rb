ActiveAdmin.register InscripcionAlumno, as: 'Pase' do

  menu label: 'Pases'

  permit_params :fecha_pase, :destino


  index do
  	#selectable_column
    column :alumno_id
    column "Nombre" do |c| 
      if c.alumno != nil
        c.alumno.nombre
      end
    end
    column "Apellido" do |c| 
      if c.alumno != nil
        c.alumno.apellido
      end
    end
    column :fecha_pase
    column :destino
    actions
  end

  filter :alumno_id, :label => 'Alumno', :as => :select, :collection => Alumno.all.order(:nombre,:apellido).map{|u| ["#{u.id} - #{u.nombre} #{u.apellido}", u.id]}

  show do
    attributes_table do
      row "Alumno" do |r| (r.alumno != nil ? "#{r.alumno.id} - #{r.alumno.nombre} #{r.alumno.apellido}" : "") end
      row :fecha_pase
      row :destino
    end
  end

  form do |f|
    a = Alumno.find(f.object.alumno_id) rescue nil
    if a != nil 
      li "#{a.id} - #{a.nombre} #{a.apellido}"
    else
      li ""
    end
    f.inputs do      
      f.input :fecha_pase
      f.input :destino
    end
    f.actions
  end

end
