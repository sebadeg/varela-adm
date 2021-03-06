ActiveAdmin.register ProximoGrado do
  menu priority: 106, label: 'Próximos Grados', parent: 'Administración'

  permit_params :nombre, :precio, :grado, :anio 


  scope :todos
  scope :corrientes


  scope :corrientes, -> { where() }
  action_item :clonar, only: :index do
    link_to "Clonar año siguiente", clonar_admin_proximo_grados_path
  end

  collection_action :clonar do
    ActiveRecord::Base.connection.execute(
      "INSERT INTO proximo_grados (nombre,grado_id,sector_id,anio,created_at,updated_at) 
       SELECT nombre,grado_id,sector_id,anio+1,now(),now() FROM proximo_grados 
       WHERE anio IN (SELECT anio_inscripciones FROM configs WHERE NOT anio_inscripciones IS NULL);" )
    redirect_to admin_proximo_grados_path
  end



  index do
  	#selectable_column
    column :nombre
    column :precio
    column "Grado" do |c| c.grado_nombre() end
    column :anio
    actions
  end

  filter :nombre
  filter :anio

  show do
    attributes_table do
      row :nombre
      row :precio
      row "Grado" do |c| c.grado_nombre() end
      row :anio
    end
  end

  form do |f|    
    f.inputs do
      f.input :nombre
      f.input :precio
      f.input :grado_id, :label => 'Grado', as: :select, collection: => Grado.coleccion()
      f.input :anio
    end
    f.actions
  end
 
  controller do

    def show
      @page_title = "#{resource.nombre_clase}: #{resource.tostr()}"
    end

    def edit
      @page_title = "#{resource.nombre_clase}: #{resource.tostr()}"
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
