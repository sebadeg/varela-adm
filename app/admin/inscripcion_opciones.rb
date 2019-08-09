ActiveAdmin.register InscripcionOpcion do

  menu label: 'Inscripción Opción', priority: 22 

  permit_params :id, :nombre, :anio, :inscripcion_opcion_tipo_id, :fecha, :valor, :formato

  index do
  	#selectable_column
    column :nombre
    column :anio
    column "Tipo" do |r| (r.inscripcion_opcion_tipo != nil ? "#{r.inscripcion_opcion_tipo.nombre}" : "" ) end
    column :fecha
    column :valor
    column :formato

    actions
  end

  filter :nombre

  show do
    attributes_table do
      row :nombre
      row :anio
      row "Tipo" do |r| (r.inscripcion_opcion_tipo != nil ? "#{r.inscripcion_opcion_tipo.nombre}" : "" ) end
      row :fecha
      row :valor
      row :formato
    end
  end

  form do |f|
    f.inputs do
      f.input :nombre
      f.input :anio
      f.input :inscripcion_opcion_tipo_id, :as => :select, :collection => InscripcionOpcionTipo.all.order(:nombre).map{|u| ["#{u.nombre}",u.id]}
      f.input :fecha
      f.input :valor
      f.input :formato
    end
    f.actions
  end

end
