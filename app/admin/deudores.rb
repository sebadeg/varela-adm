ActiveAdmin.register Deudor do

  menu label: 'Deudores'
  menu parent: 'Cuenta Corriente'

  # action_item :calcular do
  #   link_to "Calcular", calcular_admin_deudores_path
  # end

  # member_action :calcular do

  #   ActiveRecord::Base.connection.execute( "DELETE FROM deudores;" )
  #   ActiveRecord::Base.connection.execute( "ALTER SEQUENCE deudores_id_seq RESTART WITH 1;" )

  #   saldos = Hash.new
  #   fechas = Hash.new
  #   importes = Hash.new

  #   Movimiento2018.all.order(:fecha).each do |m|
      
  #     if !saldos.has_key?(m.cuenta_id)
  #       saldos[m.cuenta_id] = 0
  #       fechas[m.cuenta_id] = Array.new
  #       importes[m.cuenta_id] = Array.new
  #     end

  #     if m.importe <= 0
  #       saldos[m.cuenta_id] = saldos[m.cuenta_id] - m.importe
  #     else
  #       importes[m.cuenta_id].push(m.importe)
  #       fechas[m.cuenta_id].push(m.fecha)
  #     end

  #   end

  #   Movimiento.all.order(:fecha).each do |m|

  #     if !saldos.has_key?(m.cuenta_id)
  #       saldos[m.cuenta_id] = 0
  #       fechas[m.cuenta_id] = Array.new
  #       importes[m.cuenta_id] = Array.new
  #     end

  #     importe = m.debe-m.haber
  #     if importe <= 0
  #       saldos[m.cuenta_id] = saldos[m.cuenta_id] - importe
  #     else
  #       importes[m.cuenta_id].push(importe)
  #       fechas[m.cuenta_id].push(m.fecha)
  #     end
  #   end

  #   saldos.keys.each do |cuenta_id|
  #     while (saldos[cuenta_id] > 0) && (importes[cuenta_id].count > 0) do
  #       if importes[cuenta_id][0] <= saldos[cuenta_id]
  #         saldos[cuenta_id] = saldos[cuenta_id] - importes[cuenta_id][0];
  #         importes[cuenta_id].delete_at(0);
  #         fechas[cuenta_id].delete_at(0);
  #       else
  #         importes[cuenta_id][0] = importes[cuenta_id][0] - saldos[cuenta_id];
  #         saldos[cuenta_id] = 0;
  #       end
  #     end
  #   end

  #   saldos.keys.each do |cuenta_id|
  #     n_dias = [3600,360,180,90,60,30,0]
  #     dias = [0,0,0,0,0,0]

  #     if fechas[cuenta_id].count > 0 
  #       (0..fechas[cuenta_id].count-1).each do |i|
  #         (0..5).each do |d|
  #           if ((DateTime.now - fechas[cuenta_id][i]).to_i < n_dias[d] ) && ((DateTime.now - fechas[cuenta_id][i]).to_i >= n_dias[d+1])
  #               dias[d] = dias[d] + importes[cuenta_id][i];
  #           end
  #         end
  #       end
  #     end

  #     ActiveRecord::Base.connection.execute( "INSERT INTO deudores (cuenta_id,deuda360,deuda180,deuda90,deuda60,deuda30,deuda0,created_at,updated_at) VALUES (#{cuenta_id},#{dias[0]},#{dias[1]},#{dias[2]},#{dias[3]},#{dias[4]},#{dias[5]},now(),now());" )
  #   end

  #   redirect_to admin_deudores_path
  # end

  index do
    #selectable_column

    column "Cuenta", :cuenta_id
    column "> 360", :deuda360
    column "> 180", :deuda180
    column "> 90", :deuda90
    column "> 60", :deuda60
    column "> 30", :deuda30
    column "> 0", :deuda0
  end

  filter :cuenta_id

end