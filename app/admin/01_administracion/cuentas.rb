ActiveAdmin.register Cuenta do

  menu priority: 103, label: "Cuentas", parent: "Administración"
  
  permit_params :id, :nombre, :comentario, :info, :brou, :visa, :oca, :retencion,
    titular_cuenta_attributes: [:id,:cuenta_id,:usuario_id,:_destroy],
    cuenta_alumno_attributes: [:id,:cuenta_id,:alumno_id,:_destroy]

  scope :concurre
  scope :todos 
  scope :brou, label: "Débito BROU"
  scope :visa, label: "Débito VISA"
  scope :oca, label: "Débito OCA"

  index do
  	selectable_column
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

 show do |r|
    attributes_table do
      row :id
      row :nombre 
      row :brou
      row :visa
      row :oca
      row :retencion
      row :comentario
      row :info

      row "Titular" do 
        table_for TitularCuenta.where("cuenta_id=#{r.id}") do |t|
          t.column "Titular" do |c| c.usuario_tostr() end
        end
      end
      row "Alumnos" do 
        table_for CuentaAlumno.where("cuenta_id=#{r.id}") do |t|
          t.column "Alumno" do |c| c.alumno_tostr() end
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