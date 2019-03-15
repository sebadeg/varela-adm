ActiveAdmin.register Socio do

  menu priority: 1, parent: "SUE" 

  permit_params :id, :nombre, :apellido, :fecha_ingreso, :fecha_egreso, :cedula, :domicilio, :email, :celular, :telefono

  scope :todos 
  scope :activos
  scope :suscriptores


  index do
  	#selectable_column
 
    column :nombre
    column :apellido
    column :fecha_ingreso
    column :fecha_egreso
    column :cedula
    column :email
    column :domicilio
    column :celular
    column :telefono

    actions
  end

  filter :nombre
  filter :apellido

  show do
    attributes_table do
      row :nombre
      row :apellido
      row :fecha_ingreso
      row :fecha_egreso
      row :cedula
      row :email
      row :domicilio
      row :celular
      row :telefono
    end
  end

  form do |f|
    f.inputs do
      f.input :nombre
      f.input :apellido
      f.input :fecha_ingreso
      f.input :fecha_egreso
      f.input :cedula
      f.input :email
      f.input :domicilio
      f.input :celular
      f.input :telefono
    end
    f.actions
  end

  csv do
    column :nombre
    column :apellido
    column :fecha_ingreso
  end

	controller do

    def show
      @page_title = "Socio: "+ resource.nombre + " " + resource.apellido
    end

    def edit
      @page_title = "Socio: "+resource.nombre + " " + resource.apellido
    end

  end  

end
