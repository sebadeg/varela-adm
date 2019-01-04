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
		mail(from: 'novedades@varela.edu.uy', to: 'novedades@varela.edu.uy',  bcc: emails, subject: titulo, delivery_method_options: delivery_options)
	end


	def facturacion(usuario,mes,cuenta,filename,file)

		delivery_options = {
            address: "smtp.varela.edu.uy",
			port: 587,
		   domain: "varela.edu.uy", 
			user_name: "facturacion@varela.edu.uy",
			password: "F4c7V@r3Pr0",
		   authentication: "plain",
		   enable_starttls_auto: true,
		   openssl_verify_mode: 'none'
		}

		@usuario = usuario
		@mes = mes
		@cuenta = cuenta

        attachments[filename] = File.read(file.path)
        mail(from: 'facturacion@varela.edu.uy', to: usuario.email, bcc: 'facturacion@varela.edu.uy', subject: "Envío de copia de factura correspondiente a #{mes} de la cuenta #{cuenta}", delivery_method_options: delivery_options)
	end


	def inscribir_usuario(usuario)

		delivery_options = {
            address: "smtp.varela.edu.uy",
			port: 587,
		   domain: "varela.edu.uy", 
			user_name: "soporte@varela.edu.uy",
			password: "Ago_2018",
		   authentication: "plain",
		   enable_starttls_auto: true,
		   openssl_verify_mode: 'none'
		}

		@usuario = usuario
		mail(to: usuario.email, bcc:'soporte@varela.edu.uy', subject: 'Bienvenido al Colegio Nacional José Pedro Varela', delivery_method_options: delivery_options)
	end
end
