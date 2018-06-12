ActiveAdmin.register Lista do
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

  permit_params :nombre, :locale, lista_alumno_attributes: [:id,:lista_id,:alumno_id,:_destroy]

  menu priority: 4, label: "Lista de distribución"

  index do
    #selectable_column
    column :id
    column :nombre
    actions
  end

  filter :nombre

  show do |r|
    attributes_table do
      row :nombre
      row "Alumnos" do 
        table_for Alumno.where("id in (SELECT alumno_id FROM lista_alumnos WHERE lista_id = #{r.id})") do |t|
          t.column :nombre
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :nombre

      f.has_many :lista_alumno, heading: "Alumnos", allow_destroy: true do |l|
        l.input :alumno_id, :label => "Nombre", :as => :select, :collection => Alumno.all.order(:nombre).map{|u| [u.nombre, u.id]}
      end
    end
    f.actions
  end

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
