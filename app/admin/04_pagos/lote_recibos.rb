ActiveAdmin.register LoteRecibo do

  menu priority: 404, label: "Recibos", parent: "Pagos"

  permit_params :id,:cuenta_id,:nombre,:fecha,:suma,:concepto,:hoja_nro,:nota_credito,
    recibo_attributes: [:id,:lote_recibo_id,:importe,:cheque,:banco,:fecha_vto,:_destroy,:locale]


  action_item :agregar, only: :show do
    link_to "Añadir", new_admin_lote_recibo_path, method: :get 
  end

  action_item :imprimir, only: :show do
    link_to "Imprimir", imprimir_admin_lote_recibo_path(lote_recibo), method: :put 
  end

  member_action :imprimir, method: :put do
    id = params[:id]
    lote_recibo = LoteRecibo.find(id)
  
    file_name = "Recibo #{lote_recibo.id}.pdf"
    file = Tempfile.new(file_name)
    lote_recibo.imprimir(file.path)

    send_file(
        file.path,
        filename: file_name,
        type: "application/pdf"
      )
    
  end

  index do
  	#selectable_column
    column "Cuenta" do |r| "#{r.cuenta.id} - #{r.cuenta.nombre}" end
    column :nombre
    column :fecha
    column :concepto
    column :nota_credito
    column :suma
    column :hoja_nro

    actions
  end

  filter :cuenta_id, :label => 'Cuenta', :as => :select, :collection => Cuenta.where("NOT nombre IS NULL AND nombre != ''").order(:nombre).map{|u| [u.id.to_s + " - " + u.nombre, u.id]}
  filter :fecha

  show do
    attributes_table do
      row "Cuenta" do |r| "#{r.cuenta.id} - #{r.cuenta.nombre}" end
      row :nombre
      row :fecha
      row :concepto
      row :nota_credito
      row :suma
      row :hoja_nro
      row "Recibos" do |r|
        table_for Recibo.where("lote_recibo_id=#{r.id}").order(:id) do |t|
          t.column :fecha_vto
          t.column :cheque
          t.column :banco
          t.column :importe 
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :cuenta_id, :label => "Cuentas", :as => :select, :collection => Cuenta.where("NOT nombre IS NULL AND nombre != ''").order(:nombre).map{|u| [u.id.to_s + " - " + u.nombre, u.id]}
      f.input :nombre
      f.input :fecha
      f.input :concepto
      f.input :nota_credito
      f.input :suma
      f.input :hoja_nro
    end
    f.inputs do
      f.has_many :recibo, heading: "Recibos", allow_destroy: true, new_record: true do |l|        
        l.input :fecha_vto
        l.input :cheque
        l.input :banco
        l.input :importe
      end
    end
    f.actions
  end

  controller do

    def show
      super
      @page_title = "Recibos"
    end

    def edit
      super
      @page_title = "Recibos"
    end

    def update
      update! do |format|
        format.html { redirect_to collection_path } if resource.valid?
      end
    end

    def create
      create! do |format|
        format.html { redirect_to collection_path } if resource.valid?
      end
    end

  end

end
