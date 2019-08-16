ActiveAdmin.register Movimiento do

  config.sort_order = 'indice_asc'

  permit_params :fecha, :cuenta_id, :alumno, :descripcion, :tipo_movimiento_id, :debe, :haber

  menu priority: 201, label: "Movimientos", parent: "Cuenta Corriente"


  action_item :exportar, only: :index do
    link_to "Exportar", exportar_admin_movimientos_path
  end

  collection_action :exportar do

    file_name = "movimientos.csv"
    file = Tempfile.new(file_name)    
    File.open(file, "w+") do |f|
      Movimiento.all.order(:fecha,:cuenta_id).each do |mov|
         f.write("#{mov.fecha};#{mov.cuenta_id};#{mov.alumno};#{mov.descripcion};#{mov.debe};#{mov.haber};\r\n")
      end
    end
    send_file(
      file.path,
      filename: file_name,
      type: "application/csv"
    )
    
  end

  action_item :exportar_saico, only: :index do
    link_to "Exportar SAICO", exportar_saico_admin_movimientos_path
  end

  collection_action :exportar_saico do

    file_name = "movimientos.csv"
    file = Tempfile.new(file_name)    
    File.open(file, "w+") do |f|
      Movimiento.where("debe-haber>=0").order(:fecha,:cuenta_id).each do |mov|
         f.write("#{mov.fecha};#{mov.cuenta_id};#{mov.alumno};#{mov.descripcion};#{mov.debe-mov.haber};#{mov.cuenta_id};#{mov.rubro_haber};\r\n")
      end
      Movimiento.where("debe-haber<0").order(:fecha,:cuenta_id).each do |mov|
         f.write("#{mov.fecha};#{mov.cuenta_id};#{mov.alumno};#{mov.descripcion};#{mov.debe-mov.haber};#{mov.rubro_haber};#{mov.cuenta_id};\r\n")
      end
    end
    send_file(
      file.path,
      filename: file_name,
      type: "application/csv"
    )
    
  end


  index do
  	#selectable_column

    column "Fecha", :fecha, sortable: false
    column "Cuenta", :cuenta_id, sortable: false
    column "Alumno", :alumno, sortable: false
    column "Descripción", :descripcion, sortable: false
    column "Debe", :debe, sortable: false
    column "Haber", :haber, sortable: false
    column "Saldo", :saldo, sortable: false

    actions defaults: false do |u|
      item "Editar", edit_admin_movimiento_path(u), class: "edit_link member_link", title: "Editar" if u.fecha > DateTime.now
      item "Eliminar", admin_movimiento_path(u), class: "delete_link member_link", title:"Eliminar", "data-confirm": "¿Está seguro de que quiere eliminar esto?", rel: "nofollow", "data-method": :delete if u.fecha > DateTime.now
    end
  end

  filter :cuenta_id

  show do
    attributes_table do
      row :fecha
      row :cuenta_id
      row :alumno
      row :descripcion
      row :debe
      row :haber
    end
  end

  form do |f| 
    f.inputs "Cuentas" do
      f.input :fecha
      f.input :cuenta_id, :label => "Cuentas", :as => :select, :collection => Cuenta.where("NOT nombre IS NULL AND nombre != ''").order(:nombre).map{|u| [u.id.to_s + " - " + u.nombre, u.id]}
      f.input :alumno, :label => "Alumno", :as => :select, :collection => Alumno.all.order(:nombre,:apellido).map{|u| ["#{u.id} - #{u.nombre} #{u.apellido}", u.id]}
      f.input :tipo_movimiento_id, :label => "Tipo", :as => :select, :collection => TipoMovimiento.all.order(:nombre).map{|u| [u.nombre, u.id]}
      f.input :descripcion
      f.input :debe
      f.input :haber
    end
    f.actions
  end


  controller do

    def index
      index! do |format|


        if params[:q] != nil && params[:q][:cuenta_id_equals] != nil
          i = 0
          s = 0
          Movimiento.where("cuenta_id=#{params[:q][:cuenta_id_equals]}").order(:fecha,:tipo,:id).each do |mov|
            s = s + mov.debe - mov.haber
            mov.update(saldo: s, indice: i)
            i = i + 1
          end
        end

        format.html
      end
    end

    #   if params[:cuenta_id_equals] != nil
    #     cuenta = params[:cuenta_id_equals].to_i
    #   end
  end

end
