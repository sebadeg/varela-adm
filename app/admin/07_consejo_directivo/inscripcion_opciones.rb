ActiveAdmin.register InscripcionOpcion do

  menu priority: 701, label: "Inscripción Opción", parent: "Consejo Directivo"

  permit_params :id, :nombre, :anio, :inscripcion_opcion_tipo_id, :fecha, :valor, :formato, :general

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

  show do
    attributes_table do
      row "Tipo" do |r| (r.inscripcion_opcion_tipo != nil ? "#{r.inscripcion_opcion_tipo.nombre}" : "" ) end
      row :nombre
      row :anio
      row :general
      row :fecha
      row :valor
      row :formato
    end
  end

  form do |f|
    f.inputs do
      f.input :inscripcion_opcion_tipo_id, :as => :select, :collection => InscripcionOpcionTipo.all.order(:nombre).map{|u| ["#{u.nombre}",u.id]}
      f.input :nombre
      f.input :anio
      f.input :general
      f.input :fecha
      f.input :valor
      f.input :formato
    end
    f.actions
  end

end
