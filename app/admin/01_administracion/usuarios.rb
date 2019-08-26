ActiveAdmin.register Usuario do

  menu priority: 104, label: "Padres", parent: "Administración"

  permit_params :id, :cedula, :nombre, :apellido, :email, :direccion, :celular, :passwd,:password,:password_confirmation, :habilitado

  action_item :resetear_contrasena, only: :show do
    link_to "Resetear Contraseña", resetear_contrasena_admin_usuario_path(usuario), method: :put 
  end

  action_item :mail_bienvenida, only: :show do
    link_to "Mail Bienvenida", mail_bienvenida_admin_usuario_path(usuario), method: :put 
  end

  require 'digest/md5'

  member_action :resetear_contrasena, method: :put do
    id = params[:id]
    
    usuario = Usuario.find(id)
    passwd = Digest::MD5.hexdigest(usuario.cedula.to_s + DateTime.now.strftime('%Y%m%d%H%M%S'))[0..7]
    usuario.passwd = passwd
    usuario.save!
    usuario.update( password: passwd, password_confirmation: passwd );
    
    UserMailer.resetear_contrasena_usuario(usuario).deliver_now

    redirect_to admin_usuario_path(usuario)
  end

  member_action :mail_bienvenida, method: :put do
    id = params[:id]

    usuario = Usuario.find(id)
    passwd = Digest::MD5.hexdigest(usuario.cedula.to_s + DateTime.now.strftime('%Y%m%d%H%M%S'))[0..7]
    usuario.passwd = passwd
    usuario.save!
    usuario.update( password: passwd, password_confirmation: passwd );

    UserMailer.mail_bienvenida_usuario(usuario).deliver_now
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
    column :habilitado
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
      row :habilitado
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
      f.input :habilitado
      f.input :passwd
      f.input :password
      f.input :password_confirmation
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
      if params[:usuario][:password].blank?
        %w(password password_confirmation).each { |p| params[:usuario].delete(p) }
      end
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
