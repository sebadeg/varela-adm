ActiveAdmin.register Contrasena do

  menu priority: 908, parent: "Soporte"

  permit_params :id, :anio, :anio_pases, :anio_inscripciones, :fecha_facturacion

  index do
  	#selectable_column
    column :mail
    column :password
    actions
  end

  show do
    attributes_table do
      row :mail
      row :password
    end
  end

  form do |f|
    f.inputs do
      f.input :mail
      f.input :password
    end
    f.actions
  end

end
