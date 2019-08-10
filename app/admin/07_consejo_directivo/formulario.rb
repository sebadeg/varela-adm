ActiveAdmin.register Formulario do

  actions :all
  menu priority: 702, label: "Formularios", parent: "Consejo Directivo"

  permit_params :id, :nombre, :cedula, :anio, :proximo_grado_id,
    formulario_inscripcion_opcion_attributes: [:id,:formulario_id,:inscripcion_opcion_id,:_destroy]

  scope :todos
  scope :corrientes

  index do
    #selectable_column
    column :nombre
    column :cedula
    column :anio
    column "Grado" do |c| (c.proximo_grado != nil ? c.proximo_grado.nombre : "" ) end
    column "Total" do |c| c.precio_total() end

    actions
  end

  filter :nombre
  filter :cedula

  show do |r|
    attributes_table do
      row :nombre
      row :cedula
      row :anio
      row "Grado" do |r| (r.proximo_grado != nil ? "#{r.proximo_grado.nombre} - $U #{r.proximo_grado.precio}" : "") end      

      row "Opciones" do 
        table_for FormularioInscripcionOpcion.where("formulario_id=#{r.id}") do |t|
          t.column "Opcion" do |r| r.inscripcion_opcion.nombre_completo() end
        end
      end

    end
  end

  form partial: 'form'

end
