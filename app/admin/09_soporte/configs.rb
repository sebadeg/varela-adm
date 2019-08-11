ActiveAdmin.register Config do

  menu priority: 901, label: "Config", parent: "Soporte"

  permit_params :id, :anio, :anio_pases, :anio_inscripciones, :fecha_facturacion

  index do
  	#selectable_column
    column :anio
    column :anio_inscripciones
    column :fecha_facturacion

    actions
  end

  show do
    attributes_table do
      row :anio
      row :anio_inscripciones
      row :fecha_facturacion
    end
  end

  form do |f|
    f.inputs do
      f.input :anio
      f.input :anio_inscripciones
      f.input :fecha_facturacion
    end
    f.actions
  end

end
