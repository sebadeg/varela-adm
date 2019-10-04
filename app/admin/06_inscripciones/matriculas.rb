ActiveAdmin.register Matricula do

  menu priority: 603, label: "Matrículas", parent: "Inscripciones"

  permit_params :id, :nombre, :importe, :anio

  index do
    column :id
    column :nombre
    column :importe
    column :anio
    actions
  end

  filter :id
  filter :nombre
  filter :anio

  show do
    attributes_table do
      row :id
      row :nombre
      row :importe
      row :anio
    end
  end

  form do |f|
    f.inputs do
      f.input :id
      f.input :nombre
      f.input :importe
      f.input :anio
    end
    f.actions
  end

end
