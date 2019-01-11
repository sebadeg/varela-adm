ActiveAdmin.register Usuario do

  menu label: 'Padres', priority: 20 

  permit_params :id, :cedula, :nombre, :apellido, :email, :direccion, :celular

  action_item :contrasena, only: :show do
    link_to "Resetear Contraseña", constrasena_admin_usuario_path(usuario), method: :put 
  end

  require 'digest/md5'
  
  member_action :contrasena, method: :put do
    id = params[:id]
    usuario = Usuario.find(id)
    usuario.passwd = Digest::MD5.hexdigest(params[:usuario][:cedula] + DateTime.now.strftime('%Y%m%d%H%M%S'))[0..7])
    usuario.save!
    redirect_to admin_usuario_path(usuario)
  end

  index do
  	#selectable_column
    column :id
    column :cedula
    column :nombre
    column :apellido
    column :email
    column :direccion
    column :celular

    actions
  end

  filter :id
  filter :nombre
  filter :apellido

  show do
    attributes_table do
      row :id
      row :cedula
      row :nombre
      row :apellido
      row :email
      row :direccion
      row :celular
    end
  end

  form do |f|
    f.inputs do
      f.input :id
      f.input :cedula
      f.input :nombre
      f.input :apellido
      f.input :email
      f.input :direccion
      f.input :celular
    end
    f.actions
  end

	controller do

    def show
      @page_title = "Usuario: "+ resource.nombre + " " + resource.apellido
    end

    def edit
      @page_title = "Usuario: "+resource.nombre + " " + resource.apellido
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
