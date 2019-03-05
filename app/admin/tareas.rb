ActiveAdmin.register Tarea do

  permit_params :id, :descripcion, :tarea_tipo_id, :prioridad, :realizada

  menu priority: 1, parent: "Soporte"

  index do
  	#selectable_column
    column :descripcion
    column "Tipo" do |c| 
      if c.tarea_tipo != nil
        c.tarea_tipo.nombre
      end
    end
    column :prioridad
    column :realizada
    actions
  end

  filter :tarea_tipo_id, :label => 'Tipo', :as => :select, :collection => TareaTipo.all.order(:nombre).map{|u| ["#{u.nombre}", u.id]}
  filter :prioridad
  filter :realizada

  show do
    attributes_table do
      row :descripcion 
      row "Tipo" do |c| 
        if c.tarea_tipo != nil
          c.tarea_tipo.nombre 
        end
      end
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