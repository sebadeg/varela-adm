ActiveAdmin.register Config do

  menu priority: 901, label: "Config", parent: "Soporte"

  permit_params :id, :anio, :anio_pases

  index do
  	#selectable_column
    column :anio
    column :anio_pases
    column :anio_inscripciones
    column :fecha_facturacion

    actions
  end

  show do
    attributes_table do
      row :anio
      row :anio_pases
      row :anio_inscripciones
      row :fecha_facturacion
    end
  end

  form do |f|
    f.inputs do
      f.input :anio
      f.input :anio_pases
      f.input :anio_inscripciones
      f.input :fecha_facturacion
    end
    f.actions
  end

end
