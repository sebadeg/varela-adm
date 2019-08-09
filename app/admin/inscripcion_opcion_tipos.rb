ActiveAdmin.register InscripcionOpcionTipo do

  menu label: 'Inscripción Opción Tipo', priority: 22 

  permit_params :id, :nombre

  index do
  	#selectable_column
    column :nombre

    actions
  end

  filter :nombre

  show do
    attributes_table do
      row :nombre
    end
  end

  form do |f|
    f.inputs do
      f.input :nombre
    end
    f.actions
  end

end
