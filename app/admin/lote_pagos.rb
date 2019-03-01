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

    ActiveRecord::Base.connection.execute( 
      "INSERT INTO movimientos (pago_cuenta_id,cuenta_id,fecha,descripcion,extra,debe,haber,tipo,pendiente,created_at,updated_at)
      (SELECT pago_cuentas.id,pago_cuentas.cuenta_id,fecha,'PAGO','',0,pago_cuentas.importe,1005,false,now(),now() FROM pago_cuentas WHERE NOT id IN (SELECT pago_cuenta_id FROM movimientos WHERE NOT pago_cuenta_id IS NULL));" )

    ActiveRecord::Base.connection.execute( 
      "INSERT INTO movimientos (recibo_id,cuenta_id,fecha,descripcion,extra,debe,haber,tipo,pendiente,created_at,updated_at)
      (SELECT recibos.id,lote_recibos.cuenta_id,fecha,'PAGO','',0,recibos.importe,1005,true,now(),now() FROM
      lote_recibos INNER JOIN recibos ON lote_recibos.id=recibos.lote_recibo_id
      WHERE NOT recibos.id IN (SELECT recibo_id FROM movimientos WHERE NOT recibo_id IS NULL))" )

    redirect_to admin_pagos_path, notice: "HECHO"
  end

end