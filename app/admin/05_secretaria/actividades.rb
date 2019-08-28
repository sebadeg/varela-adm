ActiveAdmin.register Actividad do

  actions :all
  menu priority: 502, label: "Actividades", parent: "Secretaría"

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

  permit_params :id, :nombre, :fecha, :sector_id, :mail, :creada,
      actividad_archivo_attributes: [:id,:actividad_id,:nombre,:data,:indice,:_destroy],
      actividad_lista_attributes: [:id,:actividad_id,:lista_id,:_destroy],
      actividad_opcion_attributes: [:id,:actividad_id,:opcion_concepto_id,:cuotas,:importe,:fecha,:indice,:opcion,:_destroy],
      actividad_alumno_attributes: [:id,:actividad_id,:alumno_id,:opcion,:fecha,:opcion_secretaria,:fecha_secretaria,:mail,:_destroy]

  # permit_params :nombre, :descripcion, :fecha, :fechainfo, :archivo, :data, 
  #     actividad_lista_attributes: [:id,:actividad_id,:lista_id,:_destroy],
  #     actividad_opcion_attributes: [:id,:actividad_id,:valor,:opcion,:eleccion,:_destroy]

  action_item :asociar, only: :show do
    link_to "Asociar", asociar_admin_actividad_path(actividad), method: :put if !actividad.mail?
  end

  action_item :mail, only: :show do
    link_to "Mail", mail_admin_actividad_path(actividad), method: :put 
  end

  action_item :autorizar, only: :show do
    link_to "Autorizar", edit_admin_autorizar_path(actividad)
  end




  member_action :asociar, method: :put do
    id = params[:id]
    actividad = Actividad.find(id)

    ActiveRecord::Base.connection.execute( "DELETE FROM actividad_alumnos WHERE actividad_id=#{id};" )
    ActiveRecord::Base.connection.execute( "INSERT INTO actividad_alumnos (actividad_id,alumno_id,mail,created_at,updated_at) (SELECT #{id},id,false,now(),now() FROM alumnos WHERE id IN (SELECT alumno_id FROM lista_alumnos WHERE lista_id IN (SELECT lista_id FROM actividad_listas WHERE actividad_id=#{id})));" )

    redirect_to admin_actividad_path(actividad), notice: "Hecho!"
  end

  member_action :mail, method: :put do
    id = params[:id]
    actividad = Actividad.find(id)
    actividad.update(mail: true)

    SendMailActividadJob.set(wait: 10.seconds).perform_later

    redirect_to admin_actividad_path(actividad), notice: "Hecho!"
  end


  index do
    #selectable_column
    column :nombre
    column :fecha
    actions
  end

  filter :nombre
  filter :fecha
  filter :fechainfo

  show do |r|
    attributes_table do
      row :nombre
      row :fecha

      row "Archivos" do 
        table_for ActividadArchivo.where("actividad_id=#{r.id}").order(:indice) do |t|
          t.column :indice
          t.column :nombre
        end
      end

      row "Listas" do 
        table_for Lista.where("id IN (SELECT lista_id FROM actividad_listas WHERE actividad_id=#{r.id})").order(:nombre) do |t|
          t.column :nombre
        end
      end

      row "Opciones" do 
        table_for ActividadOpcion.where("actividad_id=#{r.id}").order(:indice) do |t|
          t.column :indice
          t.column "Concepto" do |r| (r.opcion_concepto != nil ? "#{r.opcion_concepto.nombre}" : "" ) end
          t.column :cuotas
          t.column :importe
          t.column :fecha
        end
      end

      row "Alumnos" do 

        table_for ActividadAlumno.joins(:alumno).where("actividad_id=#{r.id}").order("alumnos.apellido,alumnos.nombre") do |t|
          t.column "Alumno" do |r| (r.alumno != nil ? "#{r.alumno.apellido} #{r.alumno.nombre}" : "") end
          t.column :mail
          t.column "Bajado" do |r| (r.bajado != nil ? r.bajado.strftime("%b %d, %Y") : "" ) end
          t.column "Opcion" do |r| ActividadOpcion.opcion_nombre_by_id(r.opcion) end
          t.column :fecha 
          t.column "Opcion Secretaría" do |r| ActividadOpcion.opcion_nombre_by_id(r.opcion_secretaria) end
          t.column :fecha_secretaria
        end
      end

    end
  end

  form partial: 'form'
  
  # form do |f|
  #   f.inputs do
  #     f.input :nombre
  #     f.input :fecha, label: "Autorización hasta", :as => :date_picker
  #     f.input :fechainfo, label: "Información hasta", :as => :date_picker
  #   end

  #   f.inputs do
  #     f.has_many :actividad_archivo, heading: "Archivos", allow_destroy: true, new_record: true do |l|
  #       l.input :indice
  #       if l.object == nil || l.object.new_record?
  #         l.input :nombre, :input_html => { :value => "" }, as: :hidden
  #         l.input :data, as: :file, label: "Archivo"
  #       else
  #         l.input :nombre, :input_html => { :value => l.object.nombre }, as: :hidden
  #         l.input :data, as: :file, label: "Archivo ("+ l.object.nombre + ")"
  #       end
  #     end
  #   end

  #   f.inputs do
  #     f.has_many :actividad_lista, heading: "Listas", allow_destroy: true, new_record: true do |l|
  #       l.input :lista_id, :label => 'Lista', :as => :select, :collection => Lista.all.order(:id).map{|u| ["#{u.nombre}",u.id]}
  #     end
  #   end
    
  #   f.actions
  # end

  controller do

    def show
      @page_title = "Actividad: "+ resource.nombre
    end

    def edit
      @page_title = "Actividad: "+ resource.nombre
    end

    def create
      attrs = permitted_params[:actividad]

      i = 0
      begin
        if params[:actividad][:actividad_archivo_attributes] == nil || params[:actividad][:actividad_archivo_attributes][i.to_s] == nil
          i = -1
        else
          if params[:actividad][:actividad_archivo_attributes][i.to_s][:_destroy] == nil || params[:actividad][:actividad_archivo_attributes][i.to_s][:_destroy] == "0"
            p "----------"
            p "CREATE"
            p "----------"
            file = params[:actividad][:actividad_archivo_attributes][i.to_s][:data]
            if file.instance_of? ActionDispatch::Http::UploadedFile
              p "----------"
              p "ARCHIVO"
              p "----------"

              contents = file.read
              if ( (contents =~ /\%PDF-\d+\.?\d+/) == 0 )
                params[:actividad][:actividad_archivo_attributes][i.to_s][:nombre] = file.original_filename
                params[:actividad][:actividad_archivo_attributes][i.to_s][:data] = contents
              else
                params[:actividad][:actividad_archivo_attributes][i.to_s][:nombre] = ""
                params[:actividad][:actividad_archivo_attributes][i.to_s][:data] = nil
              end
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
      attrs = permitted_params[:actividad]

      i = 0
      begin
        if params[:actividad][:actividad_archivo_attributes] == nil || params[:actividad][:actividad_archivo_attributes][i.to_s] == nil
          i = -1
        else
          if params[:actividad][:actividad_archivo_attributes][i.to_s][:_destroy] == nil || params[:actividad][:actividad_archivo_attributes][i.to_s][:_destroy] == "0"
            p "----------"
            p "UPDATE"
            p "----------"
            file = params[:actividad][:actividad_archivo_attributes][i.to_s][:data]
            if file.instance_of? ActionDispatch::Http::UploadedFile
              p "----------"
              p "ARCHIVO"
              p "----------"
              contents = file.read
              if ( (contents =~ /\%PDF-\d+\.?\d+/) == 0 )
                params[:actividad][:actividad_archivo_attributes][i.to_s][:nombre] = file.original_filename
                params[:actividad][:actividad_archivo_attributes][i.to_s][:data] = contents
              else
                params[:actividad][:actividad_archivo_attributes][i.to_s][:nombre] = ""
                params[:actividad][:actividad_archivo_attributes][i.to_s][:data] = nil
              end
            end
            p "----------"
            p "----------"
            p "----------"
          end
          i = i+1
        end
      end while i >= 0

      i = 0
      begin
        if params[:actividad][:actividad_alumno_attributes] == nil || params[:actividad][:actividad_alumno_attributes][i.to_s] == nil
          i = -1
        else
          if params[:actividad][:actividad_alumno_attributes][i.to_s][:_destroy] == nil || params[:actividad][:actividad_archivo_attributes][i.to_s][:_destroy] == "0"
            p "----------"
            p "UPDATE"
            p "----------"
            
            id = params[:actividad][:actividad_alumno_attributes][i.to_s][:id]
            opcion = params[:actividad][:actividad_alumno_attributes][i.to_s][:opcion_secretaria]
            if id != nil && id != "" && opcion != nil && opcion != ""
              actividad_alumno = ActividadAlumno.find(id)
              actividad_alumno.elegir_opcion(opcion)
            else
              params[:actividad][:actividad_alumno_attributes][i.to_s][:fecha_secretaria] = ""
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

  # controller do

  #   def create
  #     attrs = permitted_params[:actividad]
      
  #     actividad = Actividad.create()
  #     actividad.importar(attrs)

  #     if attrs[:archivo] != nil
  #       params[:actividad][:archivo] = actividad.archivo
  #     end

  #     i = 0
  #     begin
  #       if params[:actividad][:actividad_opcion_attributes] == nil || params[:actividad][:actividad_opcion_attributes][i.to_s] == nil
  #         i = -1
  #       else 
  #         if params[:actividad][:actividad_opcion_attributes][i.to_s][:id] == nil
  #           actividad_id = params[:id].to_i
  #           valor = params[:actividad][:actividad_opcion_attributes][i.to_s][:valor]
  #           opcion = params[:actividad][:actividad_opcion_attributes][i.to_s][:opcion]
  #           eleccion = params[:actividad][:actividad_opcion_attributes][i.to_s][:eleccion]

  #           ActiveRecord::Base.connection.execute( "INSERT INTO actividad_opciones (actividad_id,valor,opcion,eleccion,created_at,updated_at) VALUES (#{actividad_id},#{valor},'#{opcion}','#{eleccion}',now(),now())" )
  #           params[:actividad][:actividad_opcion_attributes][i.to_s][:id] = ActividadOpcion.where("actividad_id=#{actividad_id} AND valor=#{valor}").first.id.to_s
  #           params[:actividad][:actividad_opcion_attributes][i.to_s][:valor] = valor
  #           params[:actividad][:actividad_opcion_attributes][i.to_s][:opcion] = opcion
  #           params[:actividad][:actividad_opcion_attributes][i.to_s][:eleccion] = eleccion
  #           params[:actividad][:actividad_opcion_attributes][i.to_s][:_destroy] = "0"
  #         end
  #         i = i+1
  #       end
  #     end while i >= 0

  #     i = 0
  #     begin
  #       if params[:actividad][:actividad_lista_attributes][i.to_s] == nil
  #         i = -1
  #       else 
  #         if params[:actividad][:actividad_lista_attributes][i.to_s][:id] == nil
  #           p params[:id].to_i
  #           p params[:actividad][:actividad_lista_attributes][i.to_s][:alumno_id].to_i
  #           actividad_id = actividad.id
  #           lista_id = params[:actividad][:actividad_lista_attributes][i.to_s][:lista_id].to_i
  #           ActiveRecord::Base.connection.execute( "INSERT INTO actividad_listas (actividad_id,lista_id,created_at,updated_at) VALUES (#{actividad_id},#{lista_id},now(),now())" )
  #           params[:actividad][:actividad_lista_attributes][i.to_s][:id] = ActividadLista.where("actividad_id=#{actividad_id} AND lista_id=#{lista_id}").first.id.to_s
  #           params[:actividad][:actividad_lista_attributes][i.to_s][:_destroy] = "0"
  #         end
  #         i = i+1
  #       end
  #     end while i >= 0
  #     redirect_to admin_actividad_path(actividad)
  #   end

  #   def update
  #     attrs = permitted_params[:actividad]

  #     actividad = Actividad.where(id:params[:id]).first!
  #     actividad.importar(attrs)

  #     if attrs[:archivo] != nil
  #       params[:actividad][:archivo] = actividad.archivo
  #     end


  #     i = 0
  #     begin
  #       if params[:actividad][:actividad_opcion_attributes] == nil || params[:actividad][:actividad_opcion_attributes][i.to_s] == nil
  #         i = -1
  #       else 
  #         if params[:actividad][:actividad_opcion_attributes][i.to_s][:id] == nil
  #           actividad_id = params[:id].to_i
  #           valor = params[:actividad][:actividad_opcion_attributes][i.to_s][:valor]
  #           opcion = params[:actividad][:actividad_opcion_attributes][i.to_s][:opcion]
  #           eleccion = params[:actividad][:actividad_opcion_attributes][i.to_s][:eleccion]

  #           ActiveRecord::Base.connection.execute( "INSERT INTO actividad_opciones (actividad_id,valor,opcion,eleccion,created_at,updated_at) VALUES (#{actividad_id},#{valor},'#{opcion}','#{eleccion}',now(),now())" )
  #           params[:actividad][:actividad_opcion_attributes][i.to_s][:id] = ActividadOpcion.where("actividad_id=#{actividad_id} AND valor=#{valor}").first.id.to_s
  #           params[:actividad][:actividad_opcion_attributes][i.to_s][:valor] = valor
  #           params[:actividad][:actividad_opcion_attributes][i.to_s][:opcion] = opcion
  #           params[:actividad][:actividad_opcion_attributes][i.to_s][:eleccion] = eleccion
  #           params[:actividad][:actividad_opcion_attributes][i.to_s][:_destroy] = "0"
  #         end
  #         i = i+1
  #       end
  #     end while i >= 0

  #     i = 0
  #     begin
  #       if params[:actividad][:actividad_lista_attributes][i.to_s] == nil
  #         i = -1
  #       else 
  #         if params[:actividad][:actividad_lista_attributes][i.to_s][:id] == nil
  #           p params[:id].to_i
  #           p params[:actividad][:actividad_lista_attributes][i.to_s][:alumno_id].to_i
  #           actividad_id = params[:id].to_i
  #           lista_id = params[:actividad][:actividad_lista_attributes][i.to_s][:lista_id].to_i
  #           ActiveRecord::Base.connection.execute( "INSERT INTO actividad_listas (actividad_id,lista_id,created_at,updated_at) VALUES (#{actividad_id},#{lista_id},now(),now())" )
  #           params[:actividad][:actividad_lista_attributes][i.to_s][:id] = ActividadLista.where("actividad_id=#{actividad_id} AND lista_id=#{lista_id}").first.id.to_s
  #           params[:actividad][:actividad_lista_attributes][i.to_s][:_destroy] = "0"
  #         end
  #         i = i+1
  #       end
  #     end while i >= 0

  #     update!
  #   end
    
  # end

#end
