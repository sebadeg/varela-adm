ActiveAdmin.register TareaTipo do

  permit_params :id, :nombre

  menu priority: 60, parent: :tareas

  index do
  	#selectable_column
    column :nombre
    actions
  end

  filter false

  show do
    attributes_table do
      row :nombre
    end
  end

  form do |f| 
    f.inputs "Tareas" do
      f.input :nombre
    end
    f.actions
  end

end