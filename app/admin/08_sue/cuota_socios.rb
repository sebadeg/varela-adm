ActiveAdmin.register CuotaSocio do

  menu priority: 802, label: "Cuotas", parent: "SUE"

  permit_params :id, :socio_id, :fecha, :concepto, :importe

  index do
  	#selectable_column
 
    column "Socio" do |r| r.socio_nombre_tostr() end
    column :fecha
    column :concepto
    column :importe

    actions
  end

  filter :nombre
  filter :apellido

  show do
    attributes_table do
      row "Socio" do |r| r.socio_nombre_tostr() end
      row :fecha
      row :concepto
      row :importe
    end
  end

  form do |f|
    f.inputs do
      f.input :socio_id, label: 'Socio', as: :select, collection: Socio.coleccion()
      f.input :fecha
      f.input :concepto
      f.input :importe
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
