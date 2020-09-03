ActiveAdmin.register Convenio2020 do

  menu priority: 599, label: "Convenios 2020", parent: "Inscripciones"

  permit_params :nombre, :descuento

  index do
  	#selectable_column
    column :id
    column :nombre
    column :descuento

    actions
  end

  filter :alumno_id

  show do
    attributes_table do
      row :id
      row :nombre
      row :descuento
    end
  end

  form do |f|    
    f.inputs do
      f.input :nombre
      f.input :descuento
    end
    f.actions
  end

end
