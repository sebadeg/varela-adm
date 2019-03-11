class SendEmailJob < ApplicationJob
  queue_as :default

  def perform(*args)
  	# (1..10).each do |x|
   #    factura = Factura.where("fecha='2019-03-01' AND cuenta_id=12121").first rescue nil
   #    if factura != nil
   #      cuenta_id = factura.cuenta_id
   #      file_path = Rails.root.join("temp", "factura_#{cuenta_id}_#{factura.id}.pdf")
   #      factura.imprimir(file_path,cuenta_id,factura)
   #      usuarios = Usuario.where( "id IN (SELECT usuario_id FROM titular_cuentas WHERE cuenta_id=#{cuenta_id})") rescue nil
   #      if ( usuarios != nil )
   #        usuarios.each do |usuario|
   #          UserMailer.facturacion( usuario, "Marzo 2019", cuenta_id, "factura_#{cuenta_id}_#{factura.id}.pdf", file_path ).deliver_now
   #          sleep(10)
   #        end
   #      end
   #    end  		
  	# end
  end

end



