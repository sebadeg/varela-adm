ActiveAdmin.register Formulario do

  actions :all
  menu priority: 702, label: "Formularios", parent: "Consejo Directivo"

  permit_params :id, :nombre, :cedula,
    formulario_inscripcion_opcion_attributes: [:id,:formulario_id,:inscripcion_opcion_id,:_destroy]

  index do
    #selectable_column
    column :nombre
    column :cedula
    actions
  end

  filter :nombre
  filter :cedula

  show do |r|
    attributes_table do
      row :nombre
      row :cedula

      row "Opciones" do 
        table_for InscripcionOpcion.where("formulario_id=#{r.id}") do |t|
          t.column "Opcion" do |r| r.inscripcion_opcion.nombre_completo() end
        end
      end

    end
  end

  form partial: 'form'

end
