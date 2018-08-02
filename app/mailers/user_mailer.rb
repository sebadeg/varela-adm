class UserMailer < ApplicationMailer
	def aceptar_usuario(usuario)
		@usuario = usuario
		#mail(to: usuario.email, bcc:'soporte@varela.edu.uy', subject: 'Envío de contraseña de acceso')
		mail(from: 'soporte@varela.edu.uy', to: 'soporte@varela.edu.uy', subject: 'Envío de contraseña de acceso')
	end

	def novedades(emails,titulo)

		delivery_options = {
            address: "smtp.varela.edu.uy",
			port: 587,
		   domain: "varela.edu.uy", 
			user_name: "novedades@varela.edu.uy",
			password: "varnov2018",
		   authentication: "plain",
		   enable_starttls_auto: true,
		   openssl_verify_mode: 'none'
		}

		@titulo = titulo
		mail(from: 'novedades@varela.edu.uy', to: 'novedades@varela.edu.uy',  cc: emails, subject: titulo, delivery_method_options: delivery_options)
	end
end
