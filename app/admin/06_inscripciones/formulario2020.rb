ActiveAdmin.register Formulario2020 do

  menu priority: 599, label: "Formulario 2020", parent: "Inscripciones"

  permit_params :nombre, :descuento

  index do
  	#selectable_column
    column :id
    column :nombre
    column :fecha_comienzo
    column :fecha_fin
    actions
  end

  show do
    attributes_table do
      row :nombre
      row :fecha_comienzo
      row :fecha_fin
    end
  end

  form do |f|    
    f.inputs do
      f.input :nombre
      f.input :fecha_comienzo
      f.input :fecha_fin
    end
    f.actions
  end

end
