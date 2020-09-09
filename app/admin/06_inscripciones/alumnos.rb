ActiveAdmin.register Alumno, :as => "Insc Alumnos" do

  menu priority: 598, label: "Alumnos", parent: "Inscripciones"

  permit_params :id, :nombre, :apellido, :cedula, :lugar_nacimiento, :fecha_nacimiento, :domicilio, :celular,
    :anio_ingreso, :mutualista,:emergencia,:procede


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
      row :lugar_nacimiento
      row :fecha_nacimiento
      row :domicilio
      row :celular
      row :anio_ingreso
      row :mutualista
      row :emergencia
      row :procede
    end
  end

  form do |f|
    f.inputs do
      f.input :id
      f.input :cedula
      f.input :nombre
      f.input :apellido
      f.input :lugar_nacimiento
      f.input :fecha_nacimiento
      f.input :domicilio
      f.input :celular
      f.input :anio_ingreso
      f.input :mutualista
      f.input :emergencia
      f.input :procede
    end
    f.actions
  end

end
