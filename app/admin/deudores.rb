ActiveAdmin.register_page "Deudores" do

  menu priority: 70, label: "Deudores"

  content do
    render partial: 'deudores'
  end

  controller do
  	def index
      @saldo = Hash.new
      @ultimo = Hash.new
      Movs.where("movgru=1 AND movcap=1 AND movrub=12 AND movsub=10").order(:movcta,:movfec).each do |m|
        if ( !saldo.has_key(m.movcta) )
          @saldo[m.movcta] = 0
          @saldo[m.movcta] = Date.new(2013,12,31)
        end
        @saldo[m.movcta] = @saldo[m.movcta] + m.movdeb - m.movhab
        @ultimo[m.movcta] = m.movfec
      end
  	end
  end

end