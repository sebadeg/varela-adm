ActiveAdmin.register Usuario do

  menu label: 'Usuarios', priority: 20 

  permit_params :id, :cedula, :nombre, :apellido, :email, :direccion, :celular

  index do
  	#selectable_column
    column :id
    column :cedula
    column :nombre
    column :apellido
    column :email
    column :direccion
    column :celular

    actions defaults: false do |u|
      item "Ver", admin_lista_path(u), class: "view_link member_link", title: "Ver"
      #item "Editar", edit_admin_lista_path(u), class: "edit_link member_link", title: "Editar"
      #item "Eliminar", admin_lista_path(u), class: "delete_link member_link", title:"Eliminar", "data-confirm": "¿Está seguro de que quiere eliminar esto?", rel: "nofollow", "data-method": :delete
    end
  end

  filter :id
  filter :nombre
  filter :apellido

  show do
    attributes_table do
      row :id
      row :cedula
      row :nombre
      row :apellido
      row :email
      row :direccion
      row :celular
    end
  end

  form do |f|
    f.inputs do
      f.input :id
      f.input :cedula
      f.input :nombre
      f.input :apellido
      f.input :email
      f.input :direccion
      f.input :celular
    end
    f.actions
  end

	controller do

    def show
      @page_title = "Usuario: "+ resource.nombre + " " + resource.apellido
    end

    def edit
      @page_title = "Usuario: "+resource.nombre + " " + resource.apellido
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
