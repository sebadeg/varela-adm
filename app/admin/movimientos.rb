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
    column "Saldo" do |mov| mov.cuenta_id.to_s == params[:q][:cuenta_id_equals] ? params[:saldo] = (params[:saldo].to_f + mov.debe - mov.haber).to_s : "" end
  end

  filter :cuenta_id

  controller do    

    def index
      index! do |format|
        params[:saldo] = "0"
        #@user_tasks = UserTask.where(:user_id => current_user.id).page(params[:page])
        format.html
      end
    end

    #   if params[:cuenta_id_equals] != nil
    #     cuenta = params[:cuenta_id_equals].to_i
    #   end
  end

end
