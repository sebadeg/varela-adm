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
    column "Saldo", :saldo
  end

  filter :cuenta_id

  controller do    

    def index
      index! do |format|

        ActiveRecord::Base.connection.execute( "UPDATE movimientos SET saldo=0;" )
        
        s = 0
        Movimiento.where("cuenta_id=#{params[:q][:cuenta_id_equals]}").order(:fecha,;tipo,:id).each do |mov|
          s = s + mov.debe - mov.haber
          mov.update(saldo: s)
        end
        format.html
      end
    end

    #   if params[:cuenta_id_equals] != nil
    #     cuenta = params[:cuenta_id_equals].to_i
    #   end
  end

end
