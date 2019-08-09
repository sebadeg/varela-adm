ActiveAdmin.register Config do

  menu priority: 901, label: "Config", parent: "Soporte"

  permit_params :id, :anio, :anio_pases

  index do
  	#selectable_column
    column :anio
    column :anio_pases

    actions
  end

  show do
    attributes_table do
      row :anio
      row :anio_pases
    end
  end

  form do |f|
    f.inputs do
      f.input :anio
      f.input :anio_pases
    end
    f.actions
  end

end
