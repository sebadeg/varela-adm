ActiveAdmin.register Tarea do

  permit_params :id, :descripcion, :tarea_tipo_id, :prioridad, :realizada

  menu priority: 60

  index do
  	#selectable_column
    column :id
    column :descripcion
    column "Tipo" do |c| 
      c.tarea_tipo.nombre
    end
    column :realizada
    actions
  end

  filter :tarea_tipo_id, :label => 'Tipo', :as => :select, :collection => TareaTipo.all.order(:nombre).map{|u| ["#{u.nombre}", u.id]}
  filter :prioridad
  filter :realizada

  show do
    attributes_table do
      row :id
      row :descripcion 
      row :tarea_tipo_nombre
      row :prioridad
      row :realizada
    end
  end

  form do |f| 
    f.inputs "Tareas" do
      f.input :descripcion
      f.input :tarea_tipo_id, :label => 'Tipo', :as => :select, :collection => TareaTipo.all.order(:nombre).map{|u| ["#{u.nombre}",u.id]}
      f.input :prioridad
      f.input :realizada
    end
    f.actions
  end
  
end