ActiveAdmin.register Deudor do
  actions :index

  menu priority: 203, label: "Deudores", parent: "Cuenta Corriente"

  action_item :calcular, only: :index do
    link_to "Calcular", calcular_admin_deudores_path
  end

  collection_action :calcular do

    ActiveRecord::Base.connection.execute( "DELETE FROM deudores;" )
    ActiveRecord::Base.connection.execute( "ALTER SEQUENCE deudores_id_seq RESTART WITH 1;" )

    saldos = Hash.new
    fechas = Hash.new
    importes = Hash.new

    Movimiento2018.all.order(:fecha).each do |m|
      
      if !saldos.has_key?(m.cuenta_id)
        saldos[m.cuenta_id] = 0
        fechas[m.cuenta_id] = Array.new
        importes[m.cuenta_id] = Array.new
      end

      if m.importe <= 0
        saldos[m.cuenta_id] = saldos[m.cuenta_id] - m.importe
      else
        importes[m.cuenta_id].push(m.importe)
        fechas[m.cuenta_id].push(m.fecha)
      end

    end

    Movimiento.where("fecha>='2019-01-01'").order(:fecha).each do |m|

      if ( m.fecha <= DateTime.now )
        if !saldos.has_key?(m.cuenta_id)
          saldos[m.cuenta_id] = 0
          fechas[m.cuenta_id] = Array.new
          importes[m.cuenta_id] = Array.new
        end

        if m.haber > 0
          saldos[m.cuenta_id] = saldos[m.cuenta_id] + m.haber
        else
          importes[m.cuenta_id].push(m.debe-m.haber)
          fechas[m.cuenta_id].push(m.fecha)
        end
      end
    end

    saldos.keys.each do |cuenta_id|
      while (saldos[cuenta_id] > 0) && (importes[cuenta_id].count > 0) do
        if importes[cuenta_id][0] <= saldos[cuenta_id]
          saldos[cuenta_id] = saldos[cuenta_id] - importes[cuenta_id][0];
          importes[cuenta_id].delete_at(0);
          fechas[cuenta_id].delete_at(0);
        else
          importes[cuenta_id][0] = importes[cuenta_id][0] - saldos[cuenta_id];
          saldos[cuenta_id] = 0;
        end
      end
    end

    saldos.keys.each do |cuenta_id|
      n_dias = [3600,360,180,90,60,30,0]
      dias = [0,0,0,0,0,0]

      if fechas[cuenta_id].count > 0 
        (0..fechas[cuenta_id].count-1).each do |i|
          (0..5).each do |d|
            if ((DateTime.now - fechas[cuenta_id][i]).to_i < n_dias[d] ) && ((DateTime.now - fechas[cuenta_id][i]).to_i >= n_dias[d+1])
                dias[d] = dias[d] + importes[cuenta_id][i];
            end
          end
        end
      end

      ActiveRecord::Base.connection.execute( "INSERT INTO deudores (cuenta_id,deuda360,deuda180,deuda90,deuda60,deuda30,deuda0,created_at,updated_at) VALUES (#{cuenta_id},#{dias[0]},#{dias[1]},#{dias[2]},#{dias[3]},#{dias[4]},#{dias[5]},now(),now());" )
    end

    redirect_to admin_deudores_path
  end

  index do
    #selectable_column

    column :cuenta_id
    column "Nombre" do |c|
      if c.cuenta != nil
        c.cuenta.nombre 
      end
    end
    column "Convenio" do |c|
      if c.cuenta != nil
        c.cuenta.convenio 
      end
    end
    column :deuda360
    column :deuda180
    column :deuda90
    column :deuda60
    column :deuda30
    column :deuda0
  end

  filter :cuenta_id

  csv do
    column :cuenta_id
    column "Nombre" do |c| c.cuenta != nil && c.cuenta.nombre != nil ? c.cuenta.nombre : "" end
    
    column "Mail" do |c| c.cuenta != nil ? c.cuenta.titular_mail() : "" end
    column "Celular" do |c| c.cuenta != nil ? c.cuenta.titular_celular() : "" end

    column "Convenio" do |c| c.cuenta != nil && c.cuenta.convenio != nil ? c.cuenta.convenio : "" end
    column :deuda360
    column :deuda180
    column :deuda90
    column :deuda60
    column :deuda30
    column :deuda0
  end

end