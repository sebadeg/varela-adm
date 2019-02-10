ActiveAdmin.register Aactividad do

  permit_params :nombre, :fecha, :fechainfo,
      aactividad_archivo_attributes: [:id,:aactividad_id,:nombre,:data,:_destroy],
      aactividad_opcion_attributes: [:id,:aactividad_id,:valor,:opcion,:eleccion,:fecha,:_destroy],
      aactividad_lista_attributes: [:id,:aactividad_id,:lista_id,:_destroy]

  menu label: "Actividad 2019"

  action_item :asociar, only: :show do
    link_to "Asociar", asociar_admin_aactividad_path(aactividad), method: :put 
  end

  member_action :asociar, method: :put do
    id = params[:id]
    aactividad = Aactividad.find(id)

    ActiveRecord::Base.connection.execute( "DELETE FROM aactividad_alumnos WHERE aactividad_id=#{id};" )
    ActiveRecord::Base.connection.execute( "INSERT INTO aactividad_alumnos (aactividad_id,alumno_id,created_at,updated_at) (SELECT #{id},id,now(),now() FROM alumnos WHERE id IN (SELECT alumno_id FROM lista_alumnos WHERE lista_id IN (SELECT lista_id FROM aactividad_listas WHERE aactividad_id=#{id})));" )

    redirect_to admin_aactividad_path(aactividad)
  end


  index do
    #selectable_column
    column :nombre
    column :fecha, label: "Autorización hasta" 
    column :fechainfo, label: "Información hasta" 
    actions
  end

  filter :nombre
  filter :fecha
  filter :fechainfo

  show do |r|
    attributes_table do
      row :nombre
      row :fecha, label: "Autorización hasta" 
      row :fechainfo, label: "Información hasta" 

      row "Archivos" do 
        table_for AactividadArchivo.where("aactividad_id=#{r.id}").order(:id) do |t|
          t.column :nombre
        end
      end

      row "Opciones" do 
        table_for AactividadOpcion.where("aactividad_id=#{r.id}").order(:valor) do |t|
          t.column :valor
          t.column :opcion
          t.column :eleccion
          t.column :fecha
        end
      end

      row "Listas" do 
        table_for Lista.where("id IN (SELECT lista_id FROM aactividad_listas WHERE aactividad_id=#{r.id})").order(:nombre) do |t|
          t.column :nombre
        end
      end

    end
  end

  form do |f|
    f.inputs do
      f.input :nombre
      f.input :fecha, label: "Autorización hasta", :as => :date_picker
      f.input :fechainfo, label: "Información hasta", :as => :date_picker
    end

    f.inputs do
      f.has_many :aactividad_archivo, heading: "Archivos", allow_destroy: true, new_record: true do |l|
        if l.object.new_record?
          l.input :nombre, :input_html => { :value => "" }, as: :hidden
          l.input :data, as: :file, label: "Archivo"
        else
          l.input :nombre, :input_html => { :value => l.object.nombre }, as: :hidden
          l.input :data, as: :file, label: "Archivo ("+ l.object.nombre + ")"
        end
      end
    end

    f.inputs do
      f.has_many :aactividad_opcion, heading: "Opciones", allow_destroy: true, new_record: true do |l|
        l.input :valor
        l.input :opcion
        l.input :eleccion
        l.input :fecha
      end
    end

    f.inputs do
      f.has_many :aactividad_lista, heading: "Listas", allow_destroy: true, new_record: true do |l|
        l.input :lista_id, :label => 'Lista', :as => :select, :collection => Lista.all.order(:id).map{|u| ["#{u.nombre}",u.id]}
      end
    end

    f.actions

  end

  controller do

    def create
      attrs = permitted_params[:aactividad]

      i = 0
      begin
        if params[:aactividad][:aactividad_archivo_attributes] == nil || params[:aactividad][:aactividad_archivo_attributes][i.to_s] == nil
          i = -1
        else
          if params[:aactividad][:aactividad_archivo_attributes][i.to_s][:_destroy] == "0"
            p "----------"
            p "CREATE"
            p "----------"
            file = params[:aactividad][:aactividad_archivo_attributes][i.to_s][:data]
            if file.instance_of? ActionDispatch::Http::UploadedFile
              p "----------"
              p "ARCHIVO"
              p "----------"
              params[:aactividad][:aactividad_archivo_attributes][i.to_s][:nombre] = file.original_filename
              params[:aactividad][:aactividad_archivo_attributes][i.to_s][:data] = file.read
            end
            p "----------"
            p "----------"
            p "----------"
          end
          i = i+1
        end
      end while i >= 0

      create!
    end

    def update
      attrs = permitted_params[:aactividad]

      i = 0
      begin
        if params[:aactividad][:aactividad_archivo_attributes] == nil || params[:aactividad][:aactividad_archivo_attributes][i.to_s] == nil
          i = -1
        else
          if params[:aactividad][:aactividad_archivo_attributes][i.to_s][:_destroy] == "0"
            p "----------"
            p "UPDATE"
            p "----------"
            file = params[:aactividad][:aactividad_archivo_attributes][i.to_s][:data]
            if file.instance_of? ActionDispatch::Http::UploadedFile
              p "----------"
              p "ARCHIVO"
              p "----------"
              params[:aactividad][:aactividad_archivo_attributes][i.to_s][:nombre] = file.original_filename
              params[:aactividad][:aactividad_archivo_attributes][i.to_s][:data] = file.read
            end
            p "----------"
            p "----------"
            p "----------"
          end
          i = i+1
        end
      end while i >= 0

      update!
    end
    
  end

end
