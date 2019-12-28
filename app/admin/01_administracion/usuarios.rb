ActiveAdmin.register Usuario do

  menu priority: 104, label: "Padres", parent: "Administración"

  permit_params :id, :cedula, :nombre, :apellido, :email, :direccion, :celular, :passwd,:password,:password_confirmation, :habilitado,
    padre_alumno_attributes: [:id,:alumno_id,:usuario_id,:_destroy],
    titular_cuenta_attributes: [:id,:cuenta_id,:usuario_id,:_destroy]


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

  show do |r|
    attributes_table do
      row :id
      row :cedula
      row :nombre
      row :apellido
      row :email
      row :direccion
      row :celular
      row :habilitado
      row :passwd

      row "Hijos" do 
        table_for PadreAlumno.where("usuario_id=#{r.id}") do |t|
          t.column "Hijo" do |c| c.alumno_nombre_tostr() end
        end
      end
      row "Cuentas" do 
        table_for TitularCuenta.where("usuario_id=#{r.id}") do |t|
          t.column "Cuenta" do |c| c.cuenta_nombre_tostr() end
        end
      end
    end
  end

  form partial: 'form'

  controller do

    def show
      @page_title = "#{resource.nombre_clase}: #{resource.tostr()}"
    end

    def edit
      @page_title = "#{resource.nombre_clase}: #{resource.tostr()}"
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
