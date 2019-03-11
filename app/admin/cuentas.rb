ActiveAdmin.register Cuenta do

  permit_params :id, :nombre, :comentario

  menu priority: 1, label: "Cuentas", parent: "Administración"

  scope :concurre
  scope :todos 

  index do
  	#selectable_column
    column "Cuenta" do |cuenta|
      link_to cuenta.id, admin_cuenta_path(cuenta.id)
    end
    column :nombre
    actions
  end

  filter :id, label: "Cuenta"
  filter :nombre, as: :string

 show do
    attributes_table do
      row :id
      row :nombre 
      row :brou
      row :comentario
      row :info
    end
  end

  form do |f| 
    f.inputs "Cuentas" do
      f.input :id
      f.input :nombre
      f.input :brou
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