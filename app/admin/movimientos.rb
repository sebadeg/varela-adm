ActiveAdmin.register Movimiento do

  #config.sort_order = 'fecha'


  menu label: 'Movimientos'
  menu parent: 'Cuenta Corriente'

  saldo = 0

  index do
  	#selectable_column

    column "Fecha", :fecha
    column "Cuenta", :cuenta_id
    column "Alumno", :alumno
    column "Descripción", :descripcion
    column "Debe", :debe
    column "Haber", :haber
    column "Saldo" do |mov| saldo = saldo + mov.debe - mov.haber end
  end

  filter :cuenta_id

end
