ActiveAdmin.register Cuota2020 do

  menu priority: 599, label: "Cuota 2020", parent: "Inscripciones"

  permit_params :nombre, :fecha_comienzo, :fecha_fin

  index do
  	#selectable_column
    column :nombre
    column :fecha_comienzo
    column :fecha_fin
    actions
  end

  show do
    attributes_table do
      row :nombre
      row :fecha_comienzo
      row :fecha_fin

      row "Líneas" do 
        table_for LineaCuota2020.where("cuota2020_id=#{r.id}").order(:fecha) do |t|
          t.column :fecha
          t.column :cantidad
          t.column :numerador
          t.column :denominador
        end
      end  
    end
  end

  form partial: 'form'

end
