ActiveAdmin.register_page "Deudores" do

  menu priority: 70, label: "Deudores"

  content do
    render partial: 'deudores'
  end

  controller do
  	def index
      @saldo = Hash.new
      @deuda = Hash.new
      @fecha = Hash.new
      deuda = Hash.new
      fecha = Hash.new

      fecha_desde = Date.new(2000,1,1)
      fecha_hasta = Date.new(2014,1,1)
      ultima_fecha = Date.new(2019,1,1)

      while fecha_desde < ultima_fecha do

        Mov.where("movgru=1 AND movcap=1 AND movrub=12 AND movsub=10 AND movfec>='#{fecha_desde.strftime('%Y-%m-%d')}' AND movfec<'#{fecha_hasta.strftime('%Y-%m-%d')}'").order(:movcta,:movfec).each do |m|
          if ( !@saldo.has_key?(m.movcta.to_i) )
            @saldo[m.movcta.to_i] = 0
            deuda[m.movcta.to_i] = Array.new
            fecha[m.movcta.to_i] = Array.new
          end

          d = m.movdeb - m.movhab
		  if d <= 0
		  	@saldo[m.movcta.to_i] = @saldo[m.movcta.to_i] - d
		  else
		  	deuda[m.movcta.to_i].push(d)
		  	fecha[m.movcta.to_i].push(m.movfec)
		  end

		  while @saldo[m.movcta.to_i] > 0 && deuda[m.movcta.to_i].count > 0 do
		  	if deuda[m.movcta.to_i][0] <= @saldo[m.movcta.to_i]
              @saldo[m.movcta.to_i] = @saldo[m.movcta.to_i] - deuda[m.movcta.to_i][0]
              deuda[m.movcta.to_i].delete_at(0)
              fecha[m.movcta.to_i].delete_at(0)
            else
              deuda[m.movcta.to_i][0] = deuda[m.movcta.to_i][0] - @saldo[m.movcta.to_i]
              @saldo[m.movcta.to_i] = 0
		  	end		  	
		  end
        end

      	fecha_desde = fecha_hasta
      	fecha_hasta = fecha_hasta + 30.days
      end

      @saldo.keys.each do |k|
        @fecha[k] = DateTime.now.to_date
        @deuda[k] = 0
        if deuda[k].count > 0
          @fecha[k] = fecha[k][0]
          deuda[k].each do |d|
            @deuda[k] = @deuda[k] + d
          end
        end
      end


      @saldo2 = Hash.new
      @deuda2 = Hash.new
      @fecha2 = Hash.new
      deuda = Hash.new
      fecha = Hash.new

      #Movimiento.where("id>=1300 AND fecha<='#{DateTime.now.strftime('%Y-%m-%d')}' AND (fecha>='2019-01-01' OR tipo=1005) ").order(:fecha).each do |m|
      Movimiento.where("fecha<='#{DateTime.now.strftime('%Y-%m-%d')}'").order(:fecha).each do |m|
        if ( !@saldo2.has_key?(m.cuenta_id.to_i) )
          @saldo2[m.cuenta_id.to_i] = 0
          deuda[m.cuenta_id.to_i] = Array.new
          fecha[m.cuenta_id.to_i] = Array.new
        end
        
        d = m.debe - m.haber
        if d <= 0
          @saldo2[m.cuenta_id.to_i] = @saldo2[m.cuenta_id.to_i] - d
        else
		  deuda[m.cuenta_id.to_i].push(d)
		  fecha[m.cuenta_id.to_i].push(m.fecha)
		end

		while @saldo2[m.cuenta_id.to_i] > 0 && deuda[m.cuenta_id.to_i].count > 0 do
		  if deuda[m.cuenta_id.to_i][0] <= @saldo2[m.cuenta_id.to_i]
            @saldo2[m.cuenta_id.to_i] = @saldo2[m.cuenta_id.to_i] - deuda[m.cuenta_id.to_i][0]
            deuda[m.cuenta_id.to_i].delete_at(0)
            fecha[m.cuenta_id.to_i].delete_at(0)
          else
            deuda[m.cuenta_id.to_i][0] = deuda[m.cuenta_id.to_i][0] - @saldo2[m.cuenta_id.to_i]
            @saldo2[m.cuenta_id.to_i] = 0
		  end		  	
		end
      end


      @saldo2.keys.each do |k|
        @fecha2[k] = DateTime.now.to_date
        @deuda2[k] = 0
        if deuda[k].count > 0
          @fecha2[k] = fecha[k][0]
          deuda[k].each do |d|
            @deuda2[k] = @deuda2[k] + d
          end
        end
      end

    end

  end

end