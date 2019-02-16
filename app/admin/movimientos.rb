ActiveAdmin.register Movimiento do

  config.sort_order = 'fecha_asc,tipo_asc,id_asc'


  menu label: 'Movimientos'
  menu parent: 'Cuenta Corriente'

  index do
  	#selectable_column

    column "Fecha", :fecha, sortable: false
    column "Cuenta", :cuenta_id, sortable: false
    column "Alumno", :alumno, sortable: false
    column "Descripción", :descripcion, sortable: false
    column "Debe", :debe, sortable: false
    column "Haber", :haber, sortable: false
    column "Saldo", :saldo, sortable: false
  end

  filter :cuenta_id

  controller do    

    def index
      index! do |format|

        ActiveRecord::Base.connection.execute( "UPDATE movimientos SET saldo=NULL;" )

        if params[:q] != nil && params[:q][:cuenta_id_equals] != nil
          s = 0
          Movimiento.where("cuenta_id=#{params[:q][:cuenta_id_equals]}").order(:fecha,:tipo,:id).each do |mov|
            s = s + mov.debe - mov.haber
            mov.update(saldo: s)
          end
        end

        format.html
      end
    end

    #   if params[:cuenta_id_equals] != nil
    #     cuenta = params[:cuenta_id_equals].to_i
    #   end
  end

end
