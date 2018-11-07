ActiveAdmin.register Seguimiento do

  menu label: 'Seguimiento'
  menu parent: 'Inscripciones'

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
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :alumno_id
      f.input :celular
      f.input :no_atiende
      f.input :no_inscribe
      f.input :inscribe
      f.input :duda
      f.input :comentario
      f.input :created_at
      f.input :updated_at
    end
    f.actions
  end

end
