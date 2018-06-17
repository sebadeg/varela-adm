ActiveAdmin.register Especial do

  permit_params :fecha_comienzo, :fecha_fin, :descripcion, :importe, :nombre, :data, :md5

  menu priority: 6, label: "Movimientos especiales"

  index do
    column :fecha_comienzo
    column :fecha_fin
    column :descripcion
    column :importe
    column :nombre

    actions
  end

  form do |f|
    f.inputs do
      f.input :fecha_comienzo, :as => :date_picker, input_html: { style: 'width:40%' }
      f.input :fecha_fin, as: :date_picker, input_html: { style: 'width:40%' }
      f.input :descripcion
      f.input :importe
      if f.object.new_record?
        f.input :nombre, as: :file
      end
    end

    if !f.object.new_record?
      f.inputs do
        f.has_many :especial_alumno, heading: "Alumnos", allow_destroy: true, new_record: true do |l|
          l.input :alumno_id, :label => "Nombre", :as => :select, :collection => Alumno.all.order(:nombre).map{|u| [u.nombre, u.id]}
        end
      end
    end
    f.actions
  end

  show do |r|
    attributes_table do
      row :fecha_comienzo
      row :fecha_fin
      row :descripcion
      row :importe
      row "Alumnos" do 
        table_for Alumno.where("id in (SELECT alumno_id FROM especial_alumnos WHERE especial_id=#{r.id})").order(:nombre) do |t|
          t.column :id
          t.column :nombre
        end
      end
    end
  end

  filter :nombre

  controller do
    before_action { @page_title = "Movimientos especiales" }

    def create
      attrs = permitted_params[:especial]
      
      especial = Especial.create()
      if especial.importar(attrs)
        redirect_to admin_especial_path(especial)
      else
        render :new
      end
    end

    def update
      attrs = permitted_params[:especial]

      especial = Especial.where(id:params[:id]).first!
      especial.importar(attrs)

      i = 0
      begin
        if params[:especial][:especial_alumno_attributes][i.to_s] == nil
          i = -1
        else 
          if params[:especial][:especial_alumno_attributes][i.to_s][:id] == nil

            p params[:id].to_i
            p params[:especial][:especial_alumno_attributes][i.to_s][:alumno_id].to_i
            especial_id = params[:id].to_i
            alumno_id = params[:especial][:especial_alumno_attributes][i.to_s][:alumno_id].to_i

            ActiveRecord::Base.connection.execute( "INSERT INTO especial_alumnos (especial_id,alumno_id,created_at,updated_at) VALUES (#{especial_id},#{alumno_id},now(),now())" )

            params[:especial][:especial_alumno_attributes][i.to_s][:id] = EspecialAlumno.where("especial_id=#{especial_id} AND alumno_id=#{alumno_id}").first.id.to_s
            params[:especial][:especial_alumno_attributes][i.to_s][:_destroy] = "0"

     
          end
          i = i+1
        end
      end while i >= 0
      update!
    end 
    #     redirect_to admin_especial_path(especial)
    #   else
    #     render :edit
    #   end
    # end
  end
end
