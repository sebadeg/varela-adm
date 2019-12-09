ActiveAdmin.register Alumno do

  menu priority: 101, label: "Alumnos", parent: "Administración"

  permit_params :id,
    :cedula,
    :nombre,
    :apellido,
    :lugar_nacimiento,
    :fecha_nacimiento,
    :domicilio,
    :celular,
    :mutualista,
    :emergencia,
    :procede,
    :anio_ingreso,
    padre_alumno_attributes: [:id,:usuario_id,:alumno_id,:_destroy],
    cuenta_alumno_attributes: [:id,:cuenta_id,:alumno_id,:_destroy]


  index do
    selectable_column
    id_column
    column :cedula
    column :nombre
    column :apellido
    actions
  end

  filter :id
  filter :cedula
  filter :nombre
  filter :apellido

  show do |r|
    attributes_table do
      row :id
      row :cedula
      row :nombre
      row :apellido
      row :lugar_nacimiento
      row :fecha_nacimiento
      row :domicilio
      row :celular
      row :mutualista
      row :emergencia
      row :procede
      row :anio_ingreso
      row "Padres" do 
        table_for PadreAlumno.where("alumno_id=#{r.id}") do |t|
          t.column "Padre" do |c| c.usuario_tostr() end
        end
      end
      row "Cuentas" do 
        table_for CuentaAlumno.where("alumno_id=#{r.id}") do |t|
          t.column "Cuenta" do |c| c.cuenta_tostr() end
        end
      end

    end
  end

  form partial: 'form'

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
