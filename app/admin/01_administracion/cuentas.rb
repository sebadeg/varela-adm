ActiveAdmin.register Cuenta do

  permit_params :id, :nombre, :comentario, :brou, :visa, :oca, :retencion 

  menu priority: 103, label: "Cuentas", parent: "Administración"

  scope :concurre
  scope :todos 
  scope :brou, label: "Débito BROU"
  scope :visa, label: "Débito VISA"
  scope :oca, label: "Débito OCA"

  index do
  	#selectable_column
    column "Cuenta" do |cuenta|
      link_to cuenta.id, admin_cuenta_path(cuenta.id)
    end
    column :nombre
    column :brou
    column :visa
    column :oca
    column :retencion
    actions
  end

  filter :id, label: "Cuenta"
  filter :nombre, as: :string

 show do
    attributes_table do
      row :id
      row :nombre 
      row :brou
      row :visa
      row :oca
      row :retencion
      row :comentario
      row :info
    end
  end

  form do |f| 
    f.inputs "Cuentas" do
      f.input :id
      f.input :nombre
      f.input :brou, label: "Débito BROU"
      f.input :visa
      f.input :oca
      f.input :retencion
      f.input :comentario
    end
    f.actions
  end

  controller do

    def show
      @page_title = "Cuenta #"+resource.id.to_s
    end

    def edit
      @page_title = "Cuenta #"+resource.id.to_s
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