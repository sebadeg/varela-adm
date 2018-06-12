ActiveAdmin.register Actividad do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  permit_params :nombre, :descripcion, :fecha, :fechainfo

  menu priority: 5, label: "Actividad"

  index do
    #selectable_column
    column :id
    column :nombre
    column :descripcion
    column :fecha, label: "Fecha límite del debito" 
    column :fechainfo, label: "Fecha límite del debito" 
    actions
  end

  filter :nombre
  filter :descripcion
  filter :fecha
  filter :fechainfo


  # show do |r|
  #   attributes_table do
  #     row "Titular" do |x| x.cuenta.usuario.nombre end
  #     row "Cuenta" do |x| x.cuenta.numero end
  #     row :numero
  #     row :emision
  #     row :vencimiento

  #     table_for LineaFactura.where(factura_id: r.id).order(:indice) do |t|
  #       t.column :alumno
  #       t.column :descripcion
  #       t.column :importe
  #     end

  #     row "Total" do |f| LineaFactura.where(factura_id: f.id).sum(:importe) end
  #   end
  #       #column f.alumno.nombre
  #       #column f.indice
  #       #column f.descripcion
  #       #column :importe
  # end

  # form do |f|
  #   f.inputs do
  #     f.input :cuenta_id, :label => 'Cuenta', :as => :select, :collection => Cuenta.all.map{|u| ["#{u.numero}", u.id]}
  #     f.input :numero
  #     f.input :emision
  #     f.input :vencimiento
  #     f.has_many :linea_factura, heading: "" do |l|
  #       l.input :alumno
  #       l.input :descripcion
  #       l.input :importe
  #     end
  #   end
  #   f.actions
  # end

  # action_item :descargar, only: :show do |f|
  #   link_to "Descargar", admin_descargar_factura_path(f), method: :post
  # end

  

  # controller do
  #   before_filter only: [:index] do
  #     params[:q] = { emision_gteq: '2018-01-01', emision_lteq: '2018-12-31' } if params[:commit].blank?
  #   end

  #   def show
  #     @lineas = LineaFactura.where(factura_id: 1)
  #   end
  # end

end
