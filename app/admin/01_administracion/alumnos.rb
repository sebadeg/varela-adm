ActiveAdmin.register Alumno do

  menu priority: 101, label: "Alumnos", parent: "Administración"

  permit_params :id, :nombre, :apellido, :cedula, :lugar_nacimiento, :fecha_nacimiento, :domicilio, :celular, :anio_ingreso

  index do
  	#selectable_column
    column :id
    column :nombre
    column :apellido
    column :cedula

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
      row :cedula
      row :lugar_nacimiento
      row :fecha_nacimiento
      row :domicilio
      row :celular
      row :anio_ingreso
    end
  end

  form do |f|
    f.inputs do
      f.input :id
      f.input :nombre
      f.input :apellido
      f.input :cedula
      f.input :lugar_nacimiento
      f.input :fecha_nacimiento
      f.input :domicilio
      f.input :celular
      f.input :anio_ingreso

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
