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
    redirect_to admin_pagos_path, notice: ""
  end

  page_action :extra, method: :post do
    p "Extra"
    Actividad.all.each do |a|
      if a.data == nil && a.archivo != nil
        file_path = Rails.root.join("data", a.archivo)      
        a.data = IO.binread(file_path)
        a.save!
      end
    end
    redirect_to root_path, notice: ""
  end

end