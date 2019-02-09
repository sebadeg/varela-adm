ActiveAdmin.register Aactividad do

  permit_params :nombre, :fecha, :fechainfo,
      aactividad_opcion_attributes: [:id,:aactividad_id,:valor,:opcion,:eleccion,:fecha,:_destroy],
      aactividad_lista_attributes: [:id,:aactividad_id,:lista_id,:_destroy]

  menu label: "Actividad 2019"

  index do
    #selectable_column
    column :nombre
    column :fecha, label: "Autorización hasta" 
    column :fechainfo, label: "Información hasta" 
    actions
  end

  filter :nombre
  filter :fecha
  filter :fechainfo

  show do |r|
    attributes_table do
      row :nombre
      row :fecha, label: "Autorización hasta" 
      row :fechainfo, label: "Información hasta" 

      row "Opciones" do 
        table_for AactividadOpcion.where("aactividad_id=#{r.id}").order(:valor) do |t|
          t.column :valor
          t.column :opcion
          t.column :eleccion
          t.column :fecha
        end
      end

      row "Listas" do 
        table_for AactividadLista.where("aactividad_id=#{r.id}").order(:nombre) do |t|
          t.column :nombre
        end
      end

    end
  end

  form do |f|
    f.inputs do
      f.input :nombre
      f.input :fecha, label: "Autorización hasta", :as => :date_picker
      f.input :fechainfo, label: "Información hasta", :as => :date_picker
    end

    f.inputs do
      f.has_many :aactividad_opcion, heading: "Opciones", allow_destroy: true, new_record: true do |l|
        l.input :valor
        l.input :opcion
        l.input :eleccion
        l.input :fecha
      end
    end

    f.inputs do
      f.has_many :aactividad_lista, heading: "Listas", allow_destroy: true, new_record: true do |l|
        l.input :lista_id, :label => 'Lista', :as => :select, :collection => Lista.all.order(:id).map{|u| ["#{u.nombre}",u.id]}
      end
    end

    f.actions

  end

end
