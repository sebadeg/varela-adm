ActiveAdmin.register Factura do

  menu priority: 305, label: "Facturas", parent: "Facturación"

  permit_params :id, :cuenta_id, :fecha, :fecha_vto, :total, :dolar,
    linea_factura_attributes: [:id,:factura_id,:indice,:alumno_id,:nombre_alumno,:descripcion,:importe,:_destroy]

  member_action :descargar, method: :put do
    factura = Factura.find(params[:id]) rescue nil
    if factura != nil
      file_name = "factura_#{factura.cuenta_id}_#{factura.id}.pdf"
      file = Tempfile.new(file_name)
      factura.imprimir(file.path,factura.cuenta_id,factura)

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
    column :fecha_vencimiento
    column :total
    column :dolar

    actions defaults: true do |u|
      item "Descargar", descargar_admin_factura_path(u), class: "member_link", method: :put, title: "Descargar"
    end
  end

  filter :id
  filter :cuenta_id

  show do |r|
    attributes_table do
      row :id
      row :cuenta_id
      row :fecha
      row :fecha_vencimiento
      row :total
      row :dolar

      row "Líneas" do 
        table_for LineaFactura.where("factura_id=#{r.id}").order(:indice) do |t|
          t.column :indice
          t.column :alumno_id
          t.column :nombre_alumno
          t.column :descripcion
          t.column :importe
        end
      end      
    end
  end

  form partial: 'form'

end
