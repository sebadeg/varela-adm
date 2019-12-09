ActiveAdmin.register Grado do

  menu priority: 104, label: 'Grados', parent: 'Administración'

  permit_params :id, :nombre, :proximo_grado_id

  index do
  	#selectable_column
    column :id
    column :nombre
    column :proximo_grado_id
    actions
  end

  filter :id
  filter :nombre

  show do
    attributes_table do
      row :id
      row :nombre
      row :proximo_grado_id
    end
  end

  form do |f|    
    f.inputs do
      f.input :id
      f.input :nombre
      f.input :proximo_grado_id
    end
    f.actions
  end

  controller do

    def show
      @page_title = "#{resource.nombre_clase}: #{resource.tostr()}"
    end

    def edit
      @page_title = "#{resource.nombre_clase}: #{resource.tostr()}"
    end

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
