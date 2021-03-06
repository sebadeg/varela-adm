ActiveAdmin.register InscripcionOpcion do

  menu priority: 701, label: "Inscripción Opción", parent: "Consejo Directivo"

  permit_params :id, :nombre, :anio, :inscripcion_opcion_tipo_id, :fecha, :valor, :formato, :general,
    inscripcion_opcion_cuota_attributes: [:id,:inscripcion_opcion_id,:fecha,:cantidad,:importe,:_destroy],
    inscripcion_opcion_alumno_attributes: [:id,:inscripcion_opcion_id,:cedula,:_destroy]

  index do
  	#selectable_column
    column "Tipo" do |r| (r.inscripcion_opcion_tipo != nil ? "#{r.inscripcion_opcion_tipo.nombre}" : "" ) end
    column :nombre
    column :anio
    column :general
    column :fecha
    column :valor
    column :formato

    actions
  end

  filter :nombre

  show do |r|
    attributes_table do
      row "Tipo" do |tipo| (tipo.inscripcion_opcion_tipo != nil ? "#{tipo.inscripcion_opcion_tipo.nombre}" : "" ) end
      row :nombre
      row :anio
      row :general
      row :fecha
      row :valor
      row :formato

      row "Cuotas" do 
        table_for InscripcionOpcionCuota.where("inscripcion_opcion_id=#{r.id}") do |t|
          t.column :fecha
          t.column :cantidad
          t.column :importe
        end
      end

      row "Alumnos" do 
        table_for InscripcionOpcionAlumno.where("inscripcion_opcion_id=#{r.id}") do |t|
          t.column :cedula
        end
      end

    end
  end

  form partial: 'form'
  # form do |f|
  #   f.inputs do
  #     f.input :inscripcion_opcion_tipo_id, :as => :select, :collection => InscripcionOpcionTipo.all.order(:nombre).map{|u| ["#{u.nombre}",u.id]}
  #     f.input :nombre
  #     f.input :anio
  #     f.input :general
  #     f.input :fecha
  #     f.input :valor
  #     f.input :formato
  #   end
  #   f.actions
  # end

end
