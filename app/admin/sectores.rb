ActiveAdmin.register Sector do

  permit_params :id, :nombre

  menu priority: 60, parent: "Secretaría"

  index do
  	#selectable_column
    column :nombre
    actions
  end

  show do
    attributes_table do
      row :nombre
    end
  end

  form do |f| 
    f.inputs "Sector" do
      f.input :nombre
    end
    f.actions
  end

end