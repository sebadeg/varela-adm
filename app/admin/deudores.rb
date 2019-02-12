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

      fecha_desde = Date.new(2000,12,31)
      fecha_hasta = Date.new(2014,1,1)
      ultima_fecha = Date.new(2019,1,1)

      while fecha_desde < ultima_fecha do

        Mov.where("movgru=1 AND movcap=1 AND movrub=12 AND movsub=10 AND movfec>='#{fecha_desde.strftime('%Y-%m-%d')}' AND movfec<'#{fecha_hasta.strftime('%Y-%m-%d')}'").order(:movcta,:movfec).each do |m|
          if ( !@saldo.has_key?(m.movcta) )
            @saldo[m.movcta] = 0
            deuda[m.movcta] = Array.new
            fecha[m.movcta] = Array.new
          end

          d = m.movdeb - m.movhab
		  if d <= 0
		  	@saldo[m.movcta] = @saldo[m.movcta] - d
		  else
		  	deuda[m.movcta].push(d)
		  	fecha[m.movcta].push(m.movfec)
		  end

		  while @saldo[m.movcta] > 0 && deuda[m.movcta].count > 0 do
		  	if deuda[m.movcta][0] <= @saldo[m.movcta]
              @saldo[m.movcta] = @saldo[m.movcta] - deuda[m.movcta][0]
              deuda[m.movcta].delete_at(0)
              fecha[m.movcta].delete_at(0)
            else
              deuda[m.movcta][0] = deuda[m.movcta][0] - @saldo[m.movcta]
              @saldo[m.movcta] = 0
		  	end		  	
		  end
        end

      	fecha_desde = fecha_hasta
      	fecha_hasta = fecha_hasta + 30.days
      end

      @saldo.keys.each do |k|
        @fecha[k] = Date.now
        @deuda[k] = 0
        if deuda[k].count > 0
          @fecha[k] = fecha[0]
          deuda[k].each do |d|
            @deuda[k] = @deuda[k] + d
          end
        end
      end

    end

  end

end