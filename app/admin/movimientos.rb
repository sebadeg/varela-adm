ActiveAdmin.register Movimiento do

  config.sort_order = 'fecha'


  menu label: 'Movimientos'
  menu parent: 'Cuenta Corriente'


  index do
  	#selectable_column

    column "Fecha", :fecha
    column "Cuenta", :cuenta_id
    column "Alumno", :alumno
    column "Descripción", :descripcion
    column "Debe", :debe
    column "Haber", :haber
    #if params[:cuenta_id]!=nil 
      column "Saldo", :saldo
    #end
  end

  filter :cuenta_id

  controller do

    def index
  #    if params[:cuenta_id]==nil 
  #     return
  #    end

  #    ActiveRecord::Base.connection.execute( "UPDATE movimientos SET saldo=nil WHERE cuenta_id=#{params[:cuenta_id]};" )


  #     saldo = 0;
  #     Movimiento.where( "cuenta_id=#{params[:cuenta_id]} AND fecha<='#{DateTime.now.strftime('%Y-%m-%d'}'").order(fecha: :asc).each do |mov|
  #       saldo = saldo + mov.debe - mov.haber
  #       mov.saldo = saldo
  #       mov.update!
  #     end

     end 

  end

end
