ActiveAdmin.register Alumno do

  menu priority: 101, label: "Alumnos", parent: "Administración"

  permit_params :id, :nombre, :apellido, :cedula, :lugar_nacimiento, :fecha_nacimiento, :domicilio, :celular, :anio_ingreso,
    padre_alumno_attributes: [:id,:alumno_id,:usuario_id,:_destroy],
    cuenta_alumno_attributes: [:id,:cuenta_id,:alumno_id,:_destroy]


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

  show do |r|
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
      row "Padres" do 
        table_for PadreAlumno.where("alumno_id=#{r.id}") do |t|
          t.column "Padre" do |c| (c.usuario != nil ? "#{c.usuario.nombre} #{c.usuario.apellido}" : "" ) end
        end
      end
      row "Cuentas" do 
        table_for CuentaAlumno.where("alumno_id=#{r.id}") do |t|
          t.column "Cuenta" do |c| (c.cuenta != nil ? "#{c.cuenta.id}" : "" ) end
        end
      end
    end
  end

  form partial: 'form'

  # form do |f|
  #   f.inputs do
  #     f.input :id
  #     f.input :nombre
  #     f.input :apellido
  #     f.input :cedula
  #     f.input :lugar_nacimiento
  #     f.input :fecha_nacimiento
  #     f.input :domicilio
  #     f.input :celular
  #     f.input :anio_ingreso

  #   end
  #   f.actions
  # end

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
