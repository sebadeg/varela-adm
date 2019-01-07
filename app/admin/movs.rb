ActiveAdmin.register Mov do

  menu label: 'Movimientos'
  menu parent: 'Kaldor'

  index do
  	#selectable_column

    column "Fecha", :movfec
    column "Cuenta", :placta
    column "Subcuenta", :movcta
    column "Descripción", :movdes
    column "Com", :movcom
    column "Código", :movcod
    column "Debe", :movdeb
    column "Haber", :movhab
  end

  #filter :nombre

end
