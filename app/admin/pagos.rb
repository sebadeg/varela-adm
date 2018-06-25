ActiveAdmin.register Pago do

  actions :all, :except => [:new]
  
  menu priority: 7, label: "Pagos"

  permit_params :nombre, :data, :md5

  config.filters = false

  index do
    column :nombre
    column "Total" do |c| PagoCuenta.where( "pago_id=#{c.id}" ).sum(:importe) end
    column "Total con cuenta" do |c| PagoCuenta.where( "pago_id=#{c.id} AND NOT cuenta_id IS NULL" ).sum(:importe) end

    actions
  end

  form do |f|
    f.inputs "Archivo" do
      f.input :nombre, as: :file
    end
    f.actions
  end

  show do |r|
    attributes_table do
      row :nombre
      row "Lineas" do 
        table_for PagoCuenta.where("pago_id=#{r.id}").order(:indice) do |t|
          t.column :fecha
          t.column :cuenta_id
          t.column :importe
          t.column :descripcion
        end
      end
    end
  end
  

  controller do
    def create
      attrs = permitted_params[:pago]
      
      pago = Pago.create()
      if pago.importar(attrs[:nombre])
        redirect_to admin_pago_path(pago)
      else
        render :new
      end
    end

    def update
      attrs = permitted_params[:pago]

      pago = Pago.where(id:params[:id]).first!
      if pago.importar(attrs[:nombre])
        redirect_to admin_pago_path(pago)
      else
        render :edit
      end
    end
  end
end
