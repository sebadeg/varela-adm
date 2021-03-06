ActiveAdmin.register Movimiento do

  config.sort_order = 'indice_asc'
  
  permit_params :fecha, :cuenta_id, :alumno, :descripcion, :tipo_movimiento_id, :debe, :haber, :rubro_id

  menu priority: 201, label: "Movimientos", parent: "Cuenta Corriente"

  scope :corrientes, default: true
  scope :todos 

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

    cantidad = 1
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet
    sheet.row(0).push "FechaMov","TipoAsiento","NroCuenta","Detalle","TipoImputacion","ImporteMn","Cotizacion","ImporteMe","Concepto1","Referencia1","Fecha1","Cantidad1","Concepto2","Referencia2","Fecha2","Cantidad2","Concepto3","Referencia3","Fecha3","Cantidad3","Moneda","NroTrf"
    Movimiento.where("debe-haber>=0 AND fecha>='2019-01-01' AND rubro_id!=0").order(:fecha,:cuenta_id).each do |mov|
      sheet.row(cantidad).push mov.fecha.strftime("%d/%m/%Y"),"VE",mov.cuenta_id,mov.descripcion,"D",(mov.debe-mov.haber)
      cantidad = cantidad+1
      sheet.row(cantidad).push mov.fecha.strftime("%d/%m/%Y"),"VE",mov.rubro_id,mov.descripcion,"C",(mov.debe-mov.haber)
      cantidad = cantidad+1
    end
    Movimiento.where("debe-haber<0 AND fecha>='2019-01-01' AND rubro_id!=0").order(:fecha,:cuenta_id).each do |mov|
      sheet.row(cantidad).push mov.fecha.strftime("%d/%m/%Y"),"VE",mov.rubro_id,mov.descripcion,"D",(mov.haber-mov.debe)
      cantidad = cantidad+1
      sheet.row(cantidad).push mov.fecha.strftime("%d/%m/%Y"),"VE",mov.cuenta_id,mov.descripcion,"C",(mov.haber-mov.debe)
      cantidad = cantidad+1
    end
    file_name = "asientos.xls"
    file = Tempfile.new(file_name)
    book.write file

    send_file(
      file.path,
      filename: file_name,
      type: "application/xls"
    )

  end


  index do
  	#selectable_column

    column "Fecha", :fecha, sortable: false
    column "Cuenta" do |mov| (mov.cuenta_id != nil ? link_to(mov.cuenta_id, admin_cuenta_path(mov.cuenta_id)) : "" ) end
    column "Alumno" do |mov| (mov.alumno != nil ? link_to(mov.alumno, admin_alumno_path(mov.alumno)) : "" ) end
    column "Descripción", :descripcion, sortable: false
    column "Rubro" do |mov| (mov.rubro != nil ? "#{mov.rubro.nombre}" : "" ) end
    column "Debe", :debe, sortable: false
    column "Haber", :haber, sortable: false
    column "Saldo", :saldo, sortable: false

    actions defaults: false do |u|
      item "Editar", edit_admin_movimiento_path(u), class: "edit_link member_link", title: "Editar" if current_admin_usuario.soporte || u.fecha > DateTime.now
      item "Eliminar", admin_movimiento_path(u), class: "delete_link member_link", title:"Eliminar", "data-confirm": "¿Está seguro de que quiere eliminar esto?", rel: "nofollow", "data-method": :delete if current_admin_usuario.soporte || u.fecha > DateTime.now
    end
  end

  filter :cuenta_id

  show do
    attributes_table do
      row :fecha
      row "Cuenta" do |mov| (mov.cuenta_id != nil ? link_to(mov.cuenta_id, admin_cuenta_path(mov.cuenta_id)) : "" ) end
      row "Alumno" do |mov| (mov.alumno != nil ? link_to(mov.alumno, admin_alumno_path(mov.alumno)) : "" ) end
      row :descripcion
      row "Rubro" do |mov| (mov.rubro != nil ? "#{mov.rubro.nombre}" : "" ) end

      row :debe
      row :haber
    end
  end

  form do |f| 
    f.inputs "Cuentas" do
      f.input :ejercicio
      f.input :fecha
      f.input :cuenta_id, :label => "Cuentas", :as => :select, :collection => Cuenta.where("NOT nombre IS NULL AND nombre != ''").order(:nombre).map{|u| [u.id.to_s + " - " + u.nombre, u.id]}
      f.input :alumno, :label => "Alumno", :as => :select, :collection => Alumno.all.order(:nombre,:apellido).map{|u| ["#{u.id} - #{u.nombre} #{u.apellido}", u.id]}
      f.input :descripcion
      f.input :rubro_id, :label => 'Rubro', :as => :select, :collection => Rubro.order(:nombre).map{|u| [u.nombre, u.id]}
      f.input :debe
      f.input :haber
    end
    f.actions
  end


  controller do

    # before_action only: :index do
    #   @per_page = 100
    # end

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
