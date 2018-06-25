ActiveAdmin.register Especial do

  permit_params :fecha_comienzo, :fecha_fin, :codigo_id, :descripcion, :importe, :nombre, :data, :md5

  menu priority: 6, label: "Movimientos especiales"

  index do
    column :fecha_comienzo
    column :fecha_fin
    column "Código" do |c| 
      if c.codigo != nil
        c.codigo.nombre 
      end
    end
    column :descripcion
    column :importe
    column :nombre

    column "Alumnos" do |c| EspecialAlumno.where( "especial_id=#{c.id}" ).count() end
    column "Total" do |c| EspecialAlumno.where( "especial_id=#{c.id}" ).count()*c.importe end

    actions
  end

  form do |f|
    f.inputs do
      f.input :fecha_comienzo, :as => :date_picker
      f.input :fecha_fin, as: :date_picker
      f.input :codigo_id, :label => 'Código', :as => :select, :collection => Codigo.all.map{|c| ["#{c.id} - #{c.nombre}", c.id]}
      f.input :descripcion
      f.input :importe
      f.input :nombre, as: :file, label: "("+r.archivo+")"
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
      row "Código" do |c| 
        if c.codigo != nil
          c.codigo.nombre 
        end
      end
      row :descripcion
      row :importe
      row "Cuentas" do 
        table_for Cuenta.where("id in (SELECT cuenta_id FROM especial_cuentas WHERE especial_id=#{r.id})").order(:id) do |t|
          t.column :id
        end
      end
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
        redirect_to new_admin_especial_path
      end
    end

    def update
      attrs = permitted_params[:especial]

      especial = Especial.where(id:params[:id]).first!
      especial.importar(attrs)

      params[:especial][:nombre] = especial.nombre

      if params[:especial][:especial_alumno_attributes] != nil
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
      end
      update!
    end 
    #     redirect_to admin_especial_path(especial)
    #   else
    #     render :edit
    #   end
    # end
  end
end
