ActiveAdmin.register Matricula2020 do

  menu priority: 599, label: "Matricula 2020", parent: "Inscripciones"

  permit_params :id, :nombre, :general, :fecha_comienzo, :fecha_fin,
    linea_matricula2020_attributes: [:id,:matricula2020_id,:fecha,:cantidad,:numerador,:denominador,:_destroy],
    matricula2020_alumno_attributes: [:id,:matricula2020_id,:alumno_id,:_destroy],
    matricula2020_proximo_grado_attributes: [:id,:matricula2020_id,:proximo_grado_id,:precio,:_destroy]

  index do
  	#selectable_column
    column :nombre
    column :general
    column :fecha_comienzo
    column :fecha_fin
    actions
  end

  filter :nombre

  show do |r|
    attributes_table do
      row :nombre
      row :general
      row :fecha_comienzo
      row :fecha_fin
      
      row "Líneas" do 
        table_for LineaMatricula2020.where("matricula2020_id=#{r.id}").order(:fecha) do |t|
          t.column :fecha
          t.column :cantidad
          t.column :numerador
          t.column :denominador
        end
      end  

      row "Alumnos" do 
        table_for Matricula2020Alumno.where("matricula2020_id=#{r.id}") do |t|
          t.column "Alumno" do |c| (c.alumno != nil ? c.alumno.toString() : "" ) end
        end
      end

      row "Grados" do 
        table_for Matricula2020ProximoGrado.where("matricula2020_id=#{r.id}") do |t|
          t.column "Grado" do |c| (c.proximo_grado != nil ? c.proximo_grado.toString() : "" ) end
          t.column :precio
        end
      end  


    end
  end

  form partial: 'form'

end
