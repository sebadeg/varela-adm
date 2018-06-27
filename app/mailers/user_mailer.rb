class UserMailer < ApplicationMailer

	def aceptar_usuario(usuario)
		@usuario = usuario
		#mail(to: usuario.email, bcc:'soporte@varela.edu.uy', subject: 'Envío de contraseña de acceso')
		mail(to: 'soporte@varela.edu.uy', subject: 'Envío de contraseña de acceso')
	end

	def novedades()

		delivery_options = {
			user_name: "novedades@varela.edu.uy",
			password: "varnov2018",
            address: "smtp.varela.edu.uy"
			port: 587
		}

		mail(to: 'soporte@varela.edu.uy', subject: 'Novedades', delivery_method_options: delivery_options)
	end

end
