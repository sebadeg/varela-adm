ActiveAdmin.register Matricula2020 do

  menu priority: 599, label: "Matricula 2020", parent: "Inscripciones"

  permit_params :nombre, :descuento, :fecha_comienzo, :fecha_fin

  index do
  	#selectable_column
    column :nombre
    column :fecha_comienzo
    column :fecha_fin
    actions
  end

  filter :nombre

  show do |r|
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
