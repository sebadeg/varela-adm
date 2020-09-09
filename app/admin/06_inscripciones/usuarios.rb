ActiveAdmin.register Usuario, :as => "Insc Padres" do

  menu priority: 599, label: "Padres", parent: "Inscripciones"

  permit_params :id, :cedula, :nombre, :apellido, :email, :direccion, :celular, :lugar_nacimiento,
      :fecha_nacimiento, :profesion, :trabajo, :telefono_trabajo

  index do
  	#selectable_column
    column :id
    column :cedula
    column :nombre
    column :apellido

    actions
  end

  filter :id
  filter :cedula
  filter :nombre
  filter :apellido

  show do |r|
    attributes_table do
      row :id
      row :cedula
      row :nombre
      row :apellido
      row :email
      row :direccion
      row :celular
      row :lugar_nacimiento
      row :fecha_nacimiento
      row :profesion
      row :trabajo
      row :telefono_trabajo
    end
  end

  form do |f|
    f.inputs do
      f.input :id
      f.input :cedula
      f.input :nombre
      f.input :apellido
      f.input :email
      f.input :direccion
      f.input :celular
      f.input :lugar_nacimiento
      f.input :fecha_nacimiento
      f.input :profesion
      f.input :trabajo
      f.input :telefono_trabajo
    end
    f.actions
  end

end
