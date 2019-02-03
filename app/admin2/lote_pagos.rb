ActiveAdmin.register_page "Lote_pago" do

  menu priority: 2, label: "Lote", parent: "Pagos"

  content title: proc{ "Lote de pagos" } do  
    render partial: 'lote_pagos'
  end

  page_action :importar, method: :post do
    b = true
    params[:archivos].each do |file|
      if (b)
        pago = Pago.create()
        b = pago.importar(file)
      end
    end
    redirect_to admin_pagos_path, notice: "HECHO"
  end

  page_action :acreditar, method: :post do

    #ActiveRecord::Base.connection.execute( 
    #  "INSERT INTO movimientos (pago_cuenta_id,cuenta_id,fecha,descripcion,extra,debe,haber,tipo,pendiente,created_at,updated_at)
    #  (SELECT id,cuenta_id,fecha,'PAGO','',0,importe,1005,false,now(),now() FROM pago_cuentas WHERE id>=3106 AND NOT id IN (SELECT pago_cuenta_id FROM movimientos WHERE NOT pago_cuenta_id IS NULL));" )

    p "*********"
    p "*********"
    p "Acreditar"
    p "*********"
    p "*********"

    redirect_to admin_pagos_path, notice: "HECHO"
  end

end