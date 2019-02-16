ActiveAdmin.register Movimiento do

  #config.sort_order = 'fecha'


  menu label: 'Movimientos'
  menu parent: 'Cuenta Corriente'

  #before_action :reset_saldo, only: [:index]

  saldo = 0
  @saldo = 0

  index do
  	#selectable_column

    column "Fecha", :fecha
    column "Cuenta", :cuenta_id
    column "Alumno", :alumno
    column "Descripción", :descripcion
    column "Debe", :debe
    column "Haber", :haber
    column "Saldo" do |mov| mov.cuenta_id == 12121 ? saldo = saldo + mov.debe - mov.haber : "" end
    column "@Saldo" do |mov| mov.cuenta_id == 12121 ? @saldo = @saldo + mov.debe - mov.haber : "" end
  end

  filter :cuenta_id

  controller do    
    # def reset_saldo
    #   p "-----------"
    #   p "-----------"
    #   p "Reset saldo"
    #   p "-----------"
    #   p "-----------"
    # end

    def index
      index! do |format|
        saldo = 0
        @saldo = 0

        p "---------------"
        p "---------------"
        p params[:cuenta_id]
        p "---------------"
        p "---------------"

        #@user_tasks = UserTask.where(:user_id => current_user.id).page(params[:page])
        format.html
      end
    end

    #   if params[:cuenta_id_equals] != nil
    #     cuenta = params[:cuenta_id_equals].to_i
    #   end
  end

end
