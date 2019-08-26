ActiveAdmin.register Contrasena do

  menu priority: 908, parent: "Soporte"

  permit_params :id, :mail, :password

  index do
  	#selectable_column
    column :mail
    column :password, as: :string
    actions
  end

  show do
    attributes_table do
      row :mail
      row :password, as: :string
    end
  end

  form do |f|
    f.inputs do
      f.input :mail
      f.input :password, as: :string
    end
    f.actions
  end

end
