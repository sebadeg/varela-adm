ActiveAdmin.register TareaTipo do

  permit_params :id, :nombre

  menu priority: 60, parent: :tareas

  index do
  	#selectable_column
    column :id
    column :nombre
    actions
  end

  show do
    attributes_table do
      row :id
      row :nombre
    end
  end

  form do |f| 
    f.inputs "Tareas" do
      f.input :id
      f.input :nombre
    end
    f.actions
  end

end