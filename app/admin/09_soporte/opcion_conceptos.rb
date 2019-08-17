ActiveAdmin.register OpcionConcepto do

  permit_params :id, :nombre

  menu priority: 907, label: "´Concepto de actividades", parent: "Soporte"

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
    f.inputs "Concepto" do
      f.input :id
      f.input :nombre
    end
    f.actions
  end

end