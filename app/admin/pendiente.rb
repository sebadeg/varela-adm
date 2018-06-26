ActiveAdmin.register_page "Pendiente" do

  menu priority: 70, label: "Pendiente"

  page_action :validar, method: :post do  	
  	cuenta = eval(params[:cuenta])[:value]
	ActiveRecord::Base.connection.execute( "UPDATE movimientos SET pendiente=false WHERE cuenta_id=#{cuenta} AND fecha<='2018-06-01'" )
    redirect_to admin_pendiente_path, notice: "Cuenta validada: #{cuenta}"
  end

  content do
    render partial: 'pendiente', locals:
    {
      cuentas: Cuenta.where("id IN (SELECT cuenta_id FROM movimientos WHERE fecha<='2018-06-01' AND pendiente)").order(id),
      usuarios: Usuario.where("cuenta IN (SELECT cuenta_id FROM movimientos WHERE fecha<='2018-06-01' AND pendiente)").order(id)
    }
  end

end