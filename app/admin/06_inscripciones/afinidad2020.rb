ActiveAdmin.register Afinidad2020 do

  menu priority: 605, label: "Afinidad", parent: "Inscripciones"

  permit_params :nombre, :general, :descuento, :fecha_comienzo, :fecha_fin,
    afinidad2020_alumno_attributes: [:id,:cuota2020_id,:alumno_id,:_destroy]

  index do
  	#selectable_column
    column :nombre
    column :general
    column :descuento
    column :fecha_comienzo
    column :fecha_fin
    actions
  end

  filter :nombre

  show do |r|
    attributes_table do
      row :nombre
      row :general
      row :descuento
      row :fecha_comienzo
      row :fecha_fin

      row "Alumnos" do 
        table_for Afinidad2020Alumno.where("afinidad2020_id=#{r.id}") do |t|
          t.column "Alumno" do |c| (c.alumno != nil ? c.alumno.toString() : "" ) end
        end
      end
    end
  end

  form partial: 'form'

end
