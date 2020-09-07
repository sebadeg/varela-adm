ActiveAdmin.register Hermanos2020 do

  menu priority: 599, label: "Hermanos 2020", parent: "Inscripciones"

  permit_params :nombre, :descuento, :fecha_comienzo, :fecha_fin

  index do
  	#selectable_column
    column :nombre
    column :descuento
    column :fecha_comienzo
    column :fecha_fin
    actions
  end

  show do
    attributes_table do
      row :nombre
      row :descuento
      row :fecha_comienzo
      row :fecha_fin
    end
  end

  form do |f|    
    f.inputs do
      f.input :nombre
      f.input :descuento
      f.input :fecha_comienzo
      f.input :fecha_fin
    end
    f.actions
  end

end