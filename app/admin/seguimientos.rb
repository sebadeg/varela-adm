ActiveAdmin.register Seguimiento do

  menu label: 'Seguimiento'
  menu parent: 'Seguimiento'

  permit_params :id, :alumno_id, :celular, :no_atiende, :no_inscribe, :inscribe, :duda, :comentario, :created_at, :updated_at

  index do
  	#selectable_column
    column :alumno_id
    column :created_at
  end

  filter :alumno_id

  show do
    attributes_table do
      row :alumno_id
      row :celular
      row :no_atiende
      row :no_inscribe
      row :inscribe
      row :duda
      row :comentario
    end
  end

  form do |f|
    f.inputs do
      f.input :alumno_id, input_html: { value: @alumno_id }
      f.input :celular
      f.input :no_atiende
      f.input :no_inscribe
      f.input :inscribe
      f.input :duda
      f.input :comentario
    end
    f.actions
  end

  controller do

    def index
      @alumno_id = params["q"]["alumno_id_equals"]
    end  
  end

end
