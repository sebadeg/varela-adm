ActiveAdmin.register Pago do

  actions :all, :except => [:new]
  
  menu priority: 40, label: "Pagos"

  permit_params :nombre, :data, :md5

  config.filters = false

  action_item :acreditar, only: :index do
    link_to "Acreditar", habilitar_admin_acreditar_pago_path(pago), method: :put 
  end

  member_action :acreditar, method: :put do
    #ActiveRecord::Base.connection.execute( 
    #  "INSERT INTO movimientos (pago_cuenta_id,cuenta_id,fecha,descripcion,extra,debe,haber,tipo,pendiente,created_at,updated_at)
    #  (SELECT id,cuenta_id,fecha,'PAGO','',0,importe,1005,false,now(),now() FROM pago_cuentas WHERE id>=3106 AND NOT id IN (SELECT pago_cuenta_id FROM movimientos WHERE NOT pago_cuenta_id IS NULL));" )
    p "*********"
    p "*********"
    p "Acreditar"
    p "*********"
    p "*********"
    redirect_to admin_pagos_path
  end


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
