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

  permit_params :nombre, :descripcion, :fecha, :fechainfo, :archivo, :data

  menu priority: 5, label: "Actividad"

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
    end
  end

  form do |f|
    f.inputs do
      f.input :nombre
      f.input :descripcion
      f.input :fecha, label: "Autorización hasta", :as => :date_picker, input_html: { style: 'width:40%' }
      f.input :fechainfo, label: "Información hasta", :as => :date_picker, input_html: { style: 'width:40%' } 
      f.input :archivo, as: :file
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
      if actividad.importar(attrs)
        redirect_to admin_actividad_path(actividad)
      else
        render :new
      end
    end

    def update
      attrs = permitted_params[:actividad]

      actividad = Actividad.where(id:params[:id]).first!
      if actividad.importar(attrs)
        redirect_to admin_actividad_path(actividad)
      else
        render :edit
      end
      # i = 0
      # begin
      #   if params[:especial][:especial_alumno_attributes][i.to_s] == nil
      #     i = -1
      #   else 
      #     if params[:especial][:especial_alumno_attributes][i.to_s][:id] == nil
      #       p params[:id].to_i
      #       p params[:especial][:especial_alumno_attributes][i.to_s][:alumno_id].to_i
      #       especial_id = params[:id].to_i
      #       alumno_id = params[:especial][:especial_alumno_attributes][i.to_s][:alumno_id].to_i
      #       ActiveRecord::Base.connection.execute( "INSERT INTO especial_alumnos (especial_id,alumno_id,created_at,updated_at) VALUES (#{especial_id},#{alumno_id},now(),now())" )
      #       params[:especial][:especial_alumno_attributes][i.to_s][:id] = EspecialAlumno.where("especial_id=#{especial_id} AND alumno_id=#{alumno_id}").first.id.to_s
      #       params[:especial][:especial_alumno_attributes][i.to_s][:_destroy] = "0"
      #     end
      #     i = i+1
      #   end
      # end while i >= 0
      #update!
    end
    
  end

end
