ActiveAdmin.register ActividadArchivo do

  menu label: 'Archivos'
  menu parent: 'Actividades'


  index do
  	#selectable_column
    column "Actividad", :actividad_id
    column "Nombre", :nombre
  end

  filter :actividad_id



end
