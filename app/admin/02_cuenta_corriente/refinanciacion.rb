ActiveAdmin.register Refinanciacion do

  actions :all
  menu priority: 702, label: "Refinanciaciones", parent: "Cuenta Corriente"

  permit_params :id, :cuenta_id, :fecha, :importe,
    refinanciacion_cuota_attributes: [:id,:refinanciacion_id,:fecha,:cantidad,:importe,:_destroy]


  index do
    #selectable_column
    column :cuenta_id
    column :fecha
    column :importe

    actions
  end

  filter :cuenta_id

  show do |r|
    attributes_table do
      row :cuenta_id
      row :fecha
      row :importe

      row "Cuotas" do 
        table_for Refinanciacion.where("refinanciacion_id=#{r.id}") do |t|
          t.column :fecha
          t.column :cantidad
          t.column :importe
        end
      end

    end
  end

  form partial: 'form'

end
