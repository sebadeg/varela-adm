ActiveAdmin.register Matricula do

  menu priority: 603, label: "Matrículas", parent: "Inscripciones2019"

  permit_params :id, :nombre, :importe, :anio,
    matricula_opcion_attributes: [:id,:matricula_id,:cuotas,:fecha,:_destroy]
   
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

  show do |r|
    attributes_table do
      row :id
      row :nombre
      row :importe
      row :anio

      row "Opciones" do 
        table_for MatriculaOpcion.where("matricula_id=#{r.id}").order(:cuotas) do |t|
          t.column :cuotas
          t.column :fecha
        end
      end      
    end
  end

  form partial: 'form'

end
