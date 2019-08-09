ActiveAdmin.register ProximoGrado do
  menu priority: 1210, label: 'Grados'

  permit_params :nombre, :precio, :grado, :anio 

  index do
  	#selectable_column
    column :nombre
    column :precio
    column :grado
    column :anio
    actions
  end

  filter :nombre
  filter :anio

  show do
    attributes_table do
      row :nombre
      row :precio
      row :grado
      row :anio
    end
  end

  form do |f|    
    f.inputs do
      f.input :nombre
      f.input :precio
      f.input :grado
      f.input :anio
    end
    f.actions
  end
  
end
