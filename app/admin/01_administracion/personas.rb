ActiveAdmin.register Persona do

  menu priority: 102, label: "Personas", parent: "Administración"

  permit_params :id, :nombre, :apellido, :lugar_nacimiento, :fecha_nacimiento, :email, :domicilio, :celular, :profesion, :trabajo, :telefono_trabajo

  index do
  	#selectable_column
    column :id
    column :nombre
    column :apellido
    column :lugar_nacimiento
    column :fecha_nacimiento
    column :email
    column :domicilio
    column :celular
    column :profesion
    column :trabajo
    column :telefono_trabajo

    actions
  end

  filter :id
  filter :nombre
  filter :apellido

  show do
    attributes_table do
      row :id
      row :nombre
      row :apellido
      row :lugar_nacimiento
      row :fecha_nacimiento
      row :email
      row :domicilio
      row :celular
      row :profesion
      row :trabajo
      row :telefono_trabajo
    end
  end

  form do |f|
    f.inputs do
      f.input :id
      f.input :nombre
      f.input :apellido
      f.input :lugar_nacimiento
      f.input :fecha_nacimiento
      f.input :email
      f.input :domicilio
      f.input :celular
      f.input :profesion
      f.input :trabajo
      f.input :telefono_trabajo
    end
    f.actions
  end

end
