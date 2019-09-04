class UserMailer < ApplicationMailer

	def novedades(reply_to,emails,titulo)

        mail = "novedades@varela.edu.uy"
        contrasena = Contrasena.find_by(mail: mail) rescue nil
        passwd = contrasena != nil ? contrasena.password : ""

		delivery_options = {
          address: "smtp.varela.edu.uy",
		  port: 587,
		  domain: "varela.edu.uy", 
		  user_name: mail,
		  password: passwd,
		  authentication: "plain",
		  enable_starttls_auto: true,
		  openssl_verify_mode: 'none'
		}

		@titulo = titulo
		mail(from: 'novedades@varela.edu.uy', to: "novedades@varela.edu.uy;#{reply_to}", reply_to: reply_to, bcc: emails, subject: titulo, delivery_method_options: delivery_options)
	end


	def facturacion(usuario,mes,cuenta,filename,file_path)

        mail = "facturacion@varela.edu.uy"
        contrasena = Contrasena.find_by(mail: mail) rescue nil
        passwd = contrasena != nil ? contrasena.password : ""

		delivery_options = {
            address: "smtp.varela.edu.uy",
			port: 587,
		    domain: "varela.edu.uy", 
			user_name: mail,
			password: passwd,
		   authentication: "plain",
		   enable_starttls_auto: true,
		   openssl_verify_mode: 'none'
		}

		@usuario = usuario
		@mes = mes
		@cuenta = cuenta

        attachments[filename] = File.read(file_path)
        mail(from: 'facturacion@varela.edu.uy', to: usuario.email, bcc: 'facturacion@varela.edu.uy', subject: "Envío de copia de factura correspondiente a #{mes} de la cuenta #{cuenta}", delivery_method_options: delivery_options)
	end

	def resetear_contrasena_usuario(usuario)

        mail = "soporte@varela.edu.uy"
        contrasena = Contrasena.find_by(mail: mail) rescue nil
        passwd = contrasena != nil ? contrasena.password : ""

		delivery_options = {
          address: "smtp.varela.edu.uy",
		  port: 587,
		  domain: "varela.edu.uy", 
		  user_name: mail,
		  password: passwd,
		  authentication: "plain",
		  enable_starttls_auto: true,
		  openssl_verify_mode: 'none'
		}

		@usuario = usuario
		mail(from: 'soporte@varela.edu.uy', to: usuario.email, bcc:'soporte@varela.edu.uy', subject: 'Envío de contraseña de acceso', delivery_method_options: delivery_options)
	
	end

	def mail_bienvenida_usuario(usuario)

        mail = "soporte@varela.edu.uy"
        contrasena = Contrasena.find_by(mail: mail) rescue nil
        passwd = contrasena != nil ? contrasena.password : ""

        p "------------------------"
        p "------------------------"
        p "------------------------"
        p "------------------------"
        p "------------------------"
        p mail
        p passwd
        p "------------------------"
        p "------------------------"
        p "------------------------"
        p "------------------------"
        p "------------------------"

		delivery_options = {
            address: "smtp.varela.edu.uy",
			port: 587,
		   domain: "varela.edu.uy", 
			user_name: mail,
			password: passwd,
		   authentication: "plain",
		   enable_starttls_auto: true,
		   openssl_verify_mode: 'none'
		}

		@usuario = usuario
		mail(from: 'soporte@varela.edu.uy', to: usuario.email, bcc:'soporte@varela.edu.uy', subject: 'Bienvenido al Colegio Nacional José Pedro Varela', delivery_method_options: delivery_options)
	end

    def hay_vale_usuario(usuario)

        mail = "soporte@varela.edu.uy"

		delivery_options = {
          address: "smtp.varela.edu.uy",
		  port: 587,
		  domain: "varela.edu.uy", 
		  user_name: mail,
		  password: passwd,
		  authentication: "plain",
		  enable_starttls_auto: true,
		  openssl_verify_mode: 'none'
		}

		@usuario = usuario
		mail(from: 'soporte@varela.edu.uy', to: usuario.email, bcc:'soporte@varela.edu.uy', subject: 'Envío de contraseña de acceso', delivery_method_options: delivery_options)
	
	end

end
