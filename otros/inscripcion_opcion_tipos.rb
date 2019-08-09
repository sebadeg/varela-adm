ActiveAdmin.register InscripcionOpcionTipo do

  menu priority: 903, label: "Inscripción Opción Tipo", parent: "Soporte"

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
