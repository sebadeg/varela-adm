ActiveAdmin.register InscripcionAlumno, as: 'Pase' do

  menu label: 'Pases'

  permit_params :fecha_pase, :destino


  index do
  	#selectable_column
    column :alumno_id
    column :fecha_pase
    column :destino
    actions
  end

  filter :alumno_id

  show do
    attributes_table do
      row :alumno_id
      row :fecha_pase
      row :destino
    end
  end

  form do |f|
    f.inputs do
      f.input :alumno_id
      f.input :fecha_pase
      f.input :destino
    end
    f.actions
  end

end
