ActiveAdmin.register Alumno do
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
  menu label: 'Alumnos', priority: 22 

  permit_params :id, :nombre, :apellido

  # permit_params do
  #   params = [:direccion]
  #   params.push [:nombre,:cedula] if current_usuario.admin?
  #   params
  # end


  index do
  	#selectable_column
    column :id
    column :nombre
    column :apellido

    actions
  end

  filter :id
  filter :nombre
  filter :apellido

  show do
    attributes_table do
      row :id
      row :nombre
      row :apellido
    end
  end

  form do |f|
    f.inputs do
      f.input :id
      f.input :nombre
      f.input :apellido
      # f.has_many :cuenta_alumno, heading: "Cuentas" do |ca|
      #   ca.input :cuenta_id, :label => 'Cuenta', :as => :select, :collection => Cuenta.all.map{|u| ["#{u.numero}", u.id]}
      # 	ca.input :numero
      # end
    end
    f.actions
  end

	controller do

    def show
      @page_title = "Alumno: "+ resource.nombre + " " + resource.apellido
    end

    def edit
      @page_title = "Alumno: "+resource.nombre + " " + resource.apellido
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
