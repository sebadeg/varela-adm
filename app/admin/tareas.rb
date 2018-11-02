ActiveAdmin.register Tarea do

  permit_params :id, :descripcion, :realizada

  menu priority: 60

  index do
  	#selectable_column
    column :id
    column :descripcion
    column :realizada
    actions
  end

  show do
    attributes_table do
      row :id
      row :descripcion 
      row :realizada
    end
  end

  form do |f| 
    f.inputs "Tareas" do
      f.input :descripcion
      f.input :realizada
    end
    f.actions
  end

  controller do

	  def update
	    update! do |format|
	      format.html { redirect_to collection_path } if resource.valid?
	    end
	  end

	  def create
	    create! do |format|
	      format.html { redirect_to collection_path } if resource.valid?
	    end
	  end

	end  
end