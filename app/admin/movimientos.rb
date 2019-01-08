ActiveAdmin.register Movimiento do

  menu label: 'Movimientos'
  menu parent: 'Cuenta Corriente'

  index do
  	#selectable_column

    column "Fecha", :movfec
    column "Cuenta" :cuenta_id
    column "Alumno" :alumno
    column "Descripción", :descripcion
    column "Debe", :debe
    column "Haber", :haber
  end

  filter :cuenta_id

end
