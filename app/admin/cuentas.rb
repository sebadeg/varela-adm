ActiveAdmin.register Cuenta do

  permit_params :id, :nombre, :apellido

  menu priority: 4

  index do
  	#selectable_column
    column "Cuenta" do |cuenta|
      link_to cuenta.id, admin_cuenta_path(cuenta.id)
    end
    column :nombre
    column :apellido
    actions
  end

  filter :id, label: "Cuenta"
  filter :nombre, as: :string
  filter :apellido, as: :string

 show do
    attributes_table do
      row :id
      row :nombre 
      row :apellido
    end
  end

  form do |f| 
    f.inputs "Cuentas" do
      f.input :id
      f.input :nombre
      f.input :apellido
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