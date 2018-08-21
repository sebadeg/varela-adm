ActiveAdmin.register InscripcionAlumno do
  menu label: 'InscripcionAlumno', priority: 80 

  permit_params :cedula


  index do
  	#selectable_column
    column :alumno_id
    column :cedula

    actions
  end

  filter :alumno_id
  filter :cedula

  show do
    attributes_table do
      row :alumno_id
      row :cedula
    end
  end

  form do |f|
    f.inputs do
      f.input :alumno_id
      f.input :cedula
      # f.has_many :cuenta_alumno, heading: "Cuentas" do |ca|
      #   ca.input :cuenta_id, :label => 'Cuenta', :as => :select, :collection => Cuenta.all.map{|u| ["#{u.numero}", u.id]}
      # 	ca.input :numero
      # end
    end
    f.actions
  end

end
