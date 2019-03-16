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
      (SELECT pago_cuentas.id,pago_cuentas.cuenta_id,fecha,'PAGO','',0,pago_cuentas.importe,1005,false,now(),now() 
      FROM pago_cuentas 
      WHERE NOT id IN (SELECT pago_cuenta_id FROM movimientos WHERE NOT pago_cuenta_id IS NULL));" )

    ActiveRecord::Base.connection.execute( 
      "INSERT INTO movimientos (recibo_id,cuenta_id,fecha,descripcion,extra,debe,haber,tipo,pendiente,created_at,updated_at)
      (SELECT recibos.id,lote_recibos.cuenta_id,fecha,'PAGO','',0,recibos.importe,1005,true,now(),now()
      FROM lote_recibos INNER JOIN recibos ON lote_recibos.id=recibos.lote_recibo_id
      WHERE NOT recibos.id IN (SELECT recibo_id FROM movimientos WHERE NOT recibo_id IS NULL))" )

    ActiveRecord::Base.connection.execute( 
      "INSERT INTO movimientos (especial_id,cuenta_id,alumno,fecha,descripcion,extra,debe,haber,tipo,pendiente,created_at,updated_at)
      (SELECT especiales.id,especial_alumnos.alumno_id/10,especial_alumnos.alumno_id,especiales.fecha_comienzo,especiales.descripcion,'',especiales.importe,0,1002,true,now(),now()
      FROM especiales INNER JOIN especial_alumnos ON especiales.id=especial_alumnos.especial_id
      WHERE NOT especiales.id IN (SELECT especial_id FROM movimientos WHERE NOT especial_id IS NULL ))" )

    redirect_to admin_pagos_path, notice: "Hecho!"
  end

end