ActiveAdmin.register Rubro do

  # Hecha 17/08/2019

  menu priority: 206, label: "Rubros", parent: "Cuenta Corriente"

  permit_params :id, :nombre, :descripcion

  index do
    column :id
    column :nombre
    column :descripcion
    actions
  end

  filter :id
  filter :nombre
  filter :descripcion

  show do
    attributes_table do
      row :id
      row :nombre
      row :descripcion
    end
  end

  form do |f|
    f.inputs do
      f.input :id
      f.input :nombre
      f.input :descripcion
    end
    f.actions
  end

end
