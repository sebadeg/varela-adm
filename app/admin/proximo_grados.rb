ActiveAdmin.register ProximoGrado do
  menu priority: 4002, label: 'Grados'

  permit_params :nombre, :precio, :grado, :anio 

  index do
  	#selectable_column
    column :nombre
    column :precio
    column :grado
    actions
  end

  filter :nombre

  show do
    attributes_table do
      row :nombre
      row :precio
      row :grado
    end
  end

  form do |f|    
    f.inputs do
      f.input :nombre
      f.input :precio
      f.input :grado
    end
    f.actions
  end
  
end
