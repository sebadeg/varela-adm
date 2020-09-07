ActiveAdmin.register Cuota2020 do

  menu priority: 599, label: "Cuota 2020", parent: "Inscripciones"

  permit_params :nombre, :fecha_comienzo, :fecha_fin,
    linea_cuota2020_attributes: [:id,:cuota2020_id,:fecha,:cantidad,:numerador,:denominador,:_destroy],
    cuota2020_alumno_attributes: [:id,:cuota2020_id,:alumno_id,:_destroy]

  index do
  	#selectable_column
    column :nombre
    column :general
    column :fecha_comienzo
    column :fecha_fin
    actions
  end

  show do |r|
    attributes_table do
      row :nombre
      row :general
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

      row "Alumnos" do 
        table_for Cuota2020Alumno.where("cuota2020_id=#{r.id}") do |t|
          t.column "Alumno" do |c| (c.alumno != nil ? c.alumno.toString() : "" ) end
        end
      end
    end
  end

  form partial: 'form'

end
