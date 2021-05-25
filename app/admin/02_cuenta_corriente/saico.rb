
ActiveAdmin.register_page "Saico" do

  menu priority: 210, label: "Exportar Saico", parent: "Cuenta Corriente"


  page_action :saico, method: :post do
    cantidad = 1
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet
    sheet.row(0).push "FechaMov","TipoAsiento","NroCuenta","Detalle","TipoImputacion","ImporteMn","Cotizacion","ImporteMe","Concepto1","Referencia1","Fecha1","Cantidad1","Concepto2","Referencia2","Fecha2","Cantidad2","Concepto3","Referencia3","Fecha3","Cantidad3","Moneda","NroTrf"
    Movimiento.where("debe-haber>=0 AND fecha>='#{params[:fecha_comienzo]}' AND fecha<='#{params[:fecha_final]}' AND rubro_id!=0").order(:fecha,:cuenta_id).each do |mov|
      sheet.row(cantidad).push mov.fecha.strftime("%d/%m/%Y"),"VE",mov.cuenta_id,mov.descripcion,"D",(mov.debe-mov.haber)
      cantidad = cantidad+1
      sheet.row(cantidad).push mov.fecha.strftime("%d/%m/%Y"),"VE",mov.rubro_id,mov.descripcion,"C",(mov.debe-mov.haber)
      cantidad = cantidad+1
    end
    Movimiento.where("debe-haber<0 AND fecha>='#{params[:fecha_comienzo]}' AND fecha<='#{params[:fecha_final]}' AND rubro_id!=0").order(:fecha,:cuenta_id).each do |mov|
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

  content do
    render partial: 'saico'
  end

end