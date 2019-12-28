ActiveAdmin.register PagoCuenta do

  permit_params :id, :pago_id, :cuenta_id, :fecha, :descripcion, :importe

  menu priority: 401, label: "Individual", parent: "Pagos"

  scope :todos 
  scope :sin_cuenta

  index do
    #selectable_column
    column :pago_id
    column :cuenta_id
    column :fecha
    column :descripcion
    column :importe
    actions
  end

  filter :fecha

  form do |f|
    f.inputs do
      f.input :cuenta_id, label: 'Cuenta', as: :select, :collection => Cuenta.coleccion()
      f.input :fecha, as: :date_picker
      f.input :descripcion, as: :text
      f.input :importe
    end
    f.actions
  end

end
