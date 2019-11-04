ActiveAdmin.register_page "Soporte" do

  menu priority: 910, label: "Soporte", parent: "Soporte"

  page_action :verificar_ids, method: :post do

    ActiveRecord::Base.connection.execute( 
      "SELECT setval('recibos_id_seq', (SELECT MAX(id) FROM recibos));" + 
      "SELECT setval('lote_recibos_id_seq', (SELECT MAX(id) FROM lote_recibos));"
    )

    redirect_to admin_soporte_path, notice: "Verificación de ids realizada!"
  end

  content do
    render partial: 'soporte'
  end

end