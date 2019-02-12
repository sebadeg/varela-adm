ActiveAdmin.register_page "Deudores" do

  menu priority: 70, label: "Deudores"

  content do
    render partial: 'deudores'
  end

  controller do
  	def index
      @saldo = Hash.new
      @ultimo = Hash.new

      fecha_desde = Date.new(2000,12,31)
      fecha_hasta = Date.new(2014,1,1)
      ultima_fecha = Date.new(2019,1,1)

      begin fecha_desde < ultima_fecha do
        Mov.where("movgru=1 AND movcap=1 AND movrub=12 AND movsub=10 AND movfec>='#{fecha_desde.strftime('%Y-%m-%d')}' AND movfec<'#{fecha_hasta.strftime('%Y-%m-%d')}'").order(:movcta,:movfec).each do |m|
          if ( !@saldo.has_key?(m.movcta) )
            @saldo[m.movcta] = 0
            @ultimo[m.movcta] = Date.new(2013,12,31)
          end
          @saldo[m.movcta] = @saldo[m.movcta] + m.movdeb - m.movhab
          if @saldo[m.movcta] <= 0
            @ultimo[m.movcta] = m.movfec
          end
        end
      	fecha_desde = fecha_hasta
      	fecha_hasta = fecha_hasta + 30.days
      end
    end
  end

end