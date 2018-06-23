ActiveAdmin.register Actividad do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  permit_params :nombre, :descripcion, :fecha, :fechainfo, :archivo, :data, 
      actividad_lista_attributes: [:id,:actividad_id,:lista_id,:_destroy],
      actividad_opcion_attributes: [:id,:actividad_id,:valor,:opcion,:eleccion,:_destroy]

  menu priority: 5, label: "Actividad"

  action_item :asociar, only: :show do
    link_to "Asociar", asociar_admin_actividad_path(actividad), method: :put 
  end

  member_action :asociar, method: :put do
    id = params[:id]
    actividad = Actividad.find(id)

    ActiveRecord::Base.connection.execute( "DELETE FROM actividad_alumnos WHERE actividad_id=#{id};" )
    ActiveRecord::Base.connection.execute( "INSERT INTO actividad_alumnos (actividad_id,alumno_id,created_at,updated_at) (SELECT #{id},id,now(),now() FROM alumnos WHERE id IN (SELECT alumno_id FROM lista_alumnos WHERE lista_id IN (SELECT lista_id FROM actividad_listas WHERE actividad_id=#{id})));" )

    redirect_to admin_actividad_path(actividad)
  end

  index do
    #selectable_column
    column :id
    column :nombre
    column :descripcion
    column :fecha, label: "Autorización hasta" 
    column :fechainfo, label: "Información hasta" 
    actions
  end

  filter :nombre
  filter :descripcion
  filter :fecha
  filter :fechainfo

  show do |r|
    attributes_table do
      row :id
      row :nombre
      row :descripcion
      row :fecha, label: "Autorización hasta" 
      row :fechainfo, label: "Información hasta" 
      row :archivo

      row "Opciones" do 
        table_for ActividadOpcion.where("actividad_id=#{r.id}").order(:valor) do |t|
          t.column :valor
          t.column :opcion
          t.column :eleccion
        end
      end


      row "Listas" do 
        table_for Lista.where("id in (SELECT lista_id FROM actividad_listas WHERE actividad_id=#{r.id})").order(:nombre) do |t|
          t.column :id
          t.column :nombre
        end
      end

      row "Alumnos" do 
        table_for Alumno.where("id in (SELECT alumno_id FROM actividad_alumnos WHERE actividad_id=#{r.id})").order(:nombre) do |t|
          t.column :id
          t.column :nombre
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :nombre
      f.input :descripcion
      f.input :fecha, label: "Autorización hasta", :as => :date_picker
      f.input :fechainfo, label: "Información hasta", :as => :date_picker
      if f.object.new_record?
        f.input :archivo, as: :file
      else
        f.input :archivo, as: :file, label: "Archivo ("+ f.object.archivo + ")"
      end
    end
    f.inputs do
      f.has_many :actividad_opcion, heading: "Opciones", allow_destroy: true, new_record: true do |l|
        l.input :valor
        l.input :opcion
        l.input :eleccion
      end
    end
    f.inputs do
      f.has_many :actividad_lista, heading: "Listas", allow_destroy: true, new_record: true do |l|
        l.input :lista_id, :label => "Nombre", :as => :select, :collection => Lista.all.order(:nombre).map{|u| [u.nombre, u.id]}
      end
    end
    f.actions
  end

  # action_item :descargar, only: :show do |f|
  #   link_to "Descargar", admin_descargar_factura_path(f), method: :post
  # end

  

  # controller do
  #   before_filter only: [:index] do
  #     params[:q] = { emision_gteq: '2018-01-01', emision_lteq: '2018-12-31' } if params[:commit].blank?
  #   end

  #   def show
  #     @lineas = LineaFactura.where(factura_id: 1)
  #   end
  # end

  controller do

    def create
      attrs = permitted_params[:actividad]
      
      actividad = Actividad.create()
      actividad.importar(attrs)

      params[:actividad][:archivo] = actividad.archivo

      i = 0
      begin
        if params[:actividad][:actividad_lista_attributes][i.to_s] == nil
          i = -1
        else 
          if params[:actividad][:actividad_lista_attributes][i.to_s][:id] == nil
            p params[:id].to_i
            p params[:actividad][:actividad_lista_attributes][i.to_s][:alumno_id].to_i
            actividad_id = actividad.id
            lista_id = params[:actividad][:actividad_lista_attributes][i.to_s][:lista_id].to_i
            ActiveRecord::Base.connection.execute( "INSERT INTO actividad_listas (actividad_id,lista_id,created_at,updated_at) VALUES (#{actividad_id},#{lista_id},now(),now())" )
            params[:actividad][:actividad_lista_attributes][i.to_s][:id] = ActividadLista.where("actividad_id=#{actividad_id} AND lista_id=#{lista_id}").first.id.to_s
            params[:actividad][:actividad_lista_attributes][i.to_s][:_destroy] = "0"
          end
          i = i+1
        end
      end while i >= 0
      redirect_to admin_actividad_path(actividad)
    end

    def update
      attrs = permitted_params[:actividad]

      actividad = Actividad.where(id:params[:id]).first!
      actividad.importar(attrs)

      if attrs[:archivo] != nil
        params[:actividad][:archivo] = actividad.archivo
      end


      i = 0
      begin
        if params[:actividad][:actividad_opcion_attributes] == nil || params[:actividad][:actividad_opcion_attributes][i.to_s] == nil
          i = -1
        else 
          if params[:actividad][:actividad_opcion_attributes][i.to_s][:id] == nil
            actividad_id = params[:id].to_i
            valor = params[:actividad][:actividad_opcion_attributes][i.to_s][:valor]
            opcion = params[:actividad][:actividad_opcion_attributes][i.to_s][:opcion]
            eleccion = params[:actividad][:actividad_opcion_attributes][i.to_s][:eleccion]

            ActiveRecord::Base.connection.execute( "INSERT INTO actividad_opciones (actividad_id,valor,opcion,eleccion,created_at,updated_at) VALUES (#{actividad_id},#{valor},'#{opcion}','#{eleccion}',now(),now())" )
            params[:actividad][:actividad_opcion_attributes][i.to_s][:id] = ActividadOpcion.where("actividad_id=#{actividad_id} AND valor=#{valor}").first.id.to_s
            params[:actividad][:actividad_opcion_attributes][i.to_s][:valor] = valor
            params[:actividad][:actividad_opcion_attributes][i.to_s][:opcion] = opcion
            params[:actividad][:actividad_opcion_attributes][i.to_s][:eleccion] = eleccion
            params[:actividad][:actividad_opcion_attributes][i.to_s][:_destroy] = "0"
          end
          i = i+1
        end
      end while i >= 0

      i = 0
      begin
        if params[:actividad][:actividad_lista_attributes][i.to_s] == nil
          i = -1
        else 
          if params[:actividad][:actividad_lista_attributes][i.to_s][:id] == nil
            p params[:id].to_i
            p params[:actividad][:actividad_lista_attributes][i.to_s][:alumno_id].to_i
            actividad_id = params[:id].to_i
            lista_id = params[:actividad][:actividad_lista_attributes][i.to_s][:lista_id].to_i
            ActiveRecord::Base.connection.execute( "INSERT INTO actividad_listas (actividad_id,lista_id,created_at,updated_at) VALUES (#{actividad_id},#{lista_id},now(),now())" )
            params[:actividad][:actividad_lista_attributes][i.to_s][:id] = ActividadLista.where("actividad_id=#{actividad_id} AND lista_id=#{lista_id}").first.id.to_s
            params[:actividad][:actividad_lista_attributes][i.to_s][:_destroy] = "0"
          end
          i = i+1
        end
      end while i >= 0

      update!
    end
    
  end

end
