ActiveAdmin.register Subgrado do

  menu label: 'Grados'
  menu parent: 'Secretaría'

  permit_params :id, :nombre, :apellido

  # permit_params do
  #   params = [:direccion]
  #   params.push [:nombre,:cedula] if current_usuario.admin?
  #   params
  # end


  index do
  	#selectable_column
    column :id
    column :nombre

    column "Año" do |subgrado|
      subgrado.grado.anio
    end

    actions
  end

  filter :nombre
  filter :grado_anio, as: :numeric, :label => 'Año'

  show do
    attributes_table do
      row :id
      row :nombre

      row "Año" do |subgrado| subgrado.grado.anio end
    end
  end

  form do |f|
    f.inputs do
      f.input :id
      f.input :nombre
    end
    f.actions
  end

end
