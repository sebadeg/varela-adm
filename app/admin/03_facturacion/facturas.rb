ActiveAdmin.register Factura do

  menu priority: 305, label: "Facturas", parent: "Facturación"

  member_action :descargar, method: :put do
    factura = Factura.find(params[:id]) rescue nil
    if factura != nil
      file_name = "factura_#{factura.cuenta_id}_#{factura.id}.pdf"
      file = Tempfile.new(file_name)
      factura.imprimir(file.path,cuenta_id,factura)

      send_file(
        file.path,
        filename: file_name,
        type: "application/pdf"
      )
    else
      redirect_to admin_facturas_path
    end
  end

  index do
    column :id
    column :cuenta_id
    column :fecha
    column :total
    column :dolar

    actions defaults: false do |u|
      item "Descargar", descargar_admin_factura_path(u), class: "member_link", method: :put, title: "Descargar"
    end
  end

  filter :id
  filter :cuenta_id

end
