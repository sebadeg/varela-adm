ActiveAdmin.register AdminUsuario do

  config.filters = false

  permit_params :email, :soporte, :sue, :secretaria, :administracion, :inscripciones, :password, :password_confirmation,
    usuario_sector_attributes: [:id,:admin_usuario_id,:sector_id,:indice,:_destroy]

  menu priority: 1001, label: "Usuarios", parent: "Usuarios"

  index do
    #selectable_column
    column :email
    column :soporte if current_admin_usuario.soporte?
    column :sue if current_admin_usuario.soporte?
    column :secretaria if current_admin_usuario.soporte?
    column :administracion if current_admin_usuario.soporte?
    column :inscripciones if current_admin_usuario.soporte?
    actions
  end

  show do
    attributes_table do
      row :email
      row :soporte if current_admin_usuario.soporte?
      row :sue if current_admin_usuario.soporte?
      row :secretaria if current_admin_usuario.soporte?
      row :administracion if current_admin_usuario.soporte?
      row :inscripciones if current_admin_usuario.soporte?

      if current_admin_usuario.soporte?


        row "Sectores" do 
          sectores = admin_usuario.usuario_sector.order(:indice)
          table_for sectores do |s|
          #table_for Cuenta.where("id in (SELECT cuenta_id FROM especial_cuentas WHERE especial_id=#{r.id})").order(:id) do |t|
            s.column "Nombre" do |c|
              if c.sector != nil
                c.sector.nombre
              end
            end
            s.column :indice
          end
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :soporte if current_admin_usuario.soporte?
      f.input :sue if current_admin_usuario.soporte?
      f.input :secretaria if current_admin_usuario.soporte?
      f.input :administracion if current_admin_usuario.soporte?
      f.input :inscripciones if current_admin_usuario.soporte?      
      f.input :password
      f.input :password_confirmation
    end

    if current_admin_usuario.soporte?
      f.inputs do
        f.has_many :usuario_sector, heading: "Sectores", allow_destroy: true, new_record: true do |l|
          l.input :sector_id, :label => "Sectores", :as => :select, :collection => Sector.all.order(:nombre).map{|u| [u.nombre, u.id]}
          l.input :indice
        end
      end
    end   

    f.actions
  end

  controller do

    def update
      if params[:admin_usuario][:password].blank?
        %w(password password_confirmation).each { |p| params[:admin_usuario].delete(p) }
      end
      super
    end

  end

end
