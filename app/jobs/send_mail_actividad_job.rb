class SendMailActividadJob < ApplicationJob
  queue_as :default

  def perform(*args)

    # sql=
    #   "SELECT DISTINCT foo.email FROM ( " +
    #   "SELECT usuarios.email AS email FROM usuarios INNER JOIN titular_cuentas ON usuarios.id=titular_cuentas.usuario_id WHERE "+
    #   "  titular_cuentas.cuenta_id IN (SELECT alumnos.id/10 FROM alumnos INNER JOIN actividad_alumnos ON alumnos.id=actividad_alumnos.alumno_id WHERE actividad_alumnos.actividad_id=#{id}) "+
    #   "UNION "+
    #   "SELECT usuarios.email AS email FROM usuarios INNER JOIN padre_alumnos ON usuarios.id=padre_alumnos.usuario_id WHERE "+
    #   "  padre_alumnos.alumno_id IN (SELECT alumnos.id FROM alumnos INNER JOIN actividad_alumnos ON alumnos.id=actividad_alumnos.alumno_id WHERE actividad_alumnos.actividad_id=#{id}) "+
    #   "UNION "+
    #   "SELECT mail AS email FROM sinregistro_cuentas WHERE "+
    #   "  sinregistro_cuentas.cuenta_id IN (SELECT alumnos.id/10 FROM alumnos INNER JOIN actividad_alumnos ON alumnos.id=actividad_alumnos.alumno_id WHERE actividad_alumnos.actividad_id=#{id})"  +
    #   "  AND "+
    #   "  NOT sinregistro_cuentas.cuenta_id IN (SELECT cuenta_id FROM titular_cuentas WHERE NOT titular_cuentas.cuenta_id IS NULL)"+
    #   ") AS foo ORDER BY foo.email"

    # mailsQuery = ActiveRecord::Base.connection.execute(sql)

    # emails = ""
    # mailsQuery.each do |m|
    #   emails = emails + m['email'] + ";"
    # end

    Actividad.joins(:actividad_alumno).where("actividades.mail AND (actividad_alumnos.mail IS NULL OR NOT actividad_alumnos.mail)").each do |actividad|
      
      emails = ""
      ActividadAlumno.joins(:actividad).where("actividades.id=#{actividad.id} AND (actividad_alumnos.mail IS NULL OR NOT actividad_alumnos.mail)").limit(100).each do |actividad_alumno|

        Usuario.joins(:titular_cuenta).where("cuenta_id=#{actividad_alumno.alumno_id/10}").each do |usuario|
          emails = emails + "#{usuario.email};"
        end
        Usuario.joins(:padre_alumno).where("alumno_id=#{actividad_alumno.alumno_id}").each do |usuario|
          emails = emails + "#{usuario.email};"
        end

        ActividadAlumno.find(actividad_alumno.id).update(mail: true)

      end

      if actividad.creada == nil || actividad.creada == ""
        reply_to = "novedades@varela.edu.uy"
      else
        reply_to = actividad.creada
      end
      if emails != ""
        p "----------"
        p "----------"
        p "----------"
        p "----------"
        p "----------"
        p "#{actividad.nombre} - #{reply_to} #{emails}"
        p "----------"
        p "----------"
        p "----------"
        p "----------"
        p "----------"
        UserMailer.novedades( reply_to, emails, actividad.nombre ).deliver_now
      end
    end

  end
end
