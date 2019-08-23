class Ability   
  include CanCan::Ability



  def initialize(user)

    puts "Usuario " + user.email

    anio = Config.find(1).anio
    anio_pases = Config.find(1).anio_pases

    if user.soporte
      can :manage, :all
      return
    end

    can :manage, ActiveAdmin::Page, name: "Dashboard"
    can :manage, ActiveAdmin::Comment
    can :read, AdminUsuario, id: user.id 
    can :update, AdminUsuario, id: user.id      

    if user.sue
      can :manage, Socio
      can :manage, CuotaSocio
      can :manage, InscripcionOpcion
      can :manage, Formulario
    end

    if user.administracion
      can :manage, Mov
      can :manage, Placta
      can :manage, Movimiento
      can :manage, Deudor

      can :manage, Recibo
      can :manage, LoteRecibo
      can :manage, ActiveAdmin::Page, :name => "Estimación"

      can :manage, Especial
      can :manage, Pago
      can :manage, ActiveAdmin::Page, :name => "Lote_pago"
      can :manage, PagoCuenta
      can :manage, Cuenta
      can :manage, Alumno
      can :manage, Tarea
      can :read, Usuario
      can :manage, Contrato
      can :manage, Recargo

      can :manage, Refinanciacion
      can :manage, RefinanciacionCuota

    end

    if user.secretaria

      pases = Pase.where("alumno_id IN (SELECT alumno_id FROM lista_alumnos WHERE lista_id IN (SELECT id FROM listas WHERE sector_id IN (SELECT sector_id FROM usuario_sectores WHERE admin_usuario_id=#{user.id}) AND anio=#{anio_pases}))")
      can :read, Pase, pases do |x|
        true
      end
      can :update, Pase, pases do |x|
        true
      end
      can :manage, Lista, Lista.where("sector_id IN (SELECT sector_id FROM usuario_sectores WHERE admin_usuario_id=#{user.id}) AND anio IN (SELECT anio FROM configs WHERE NOT anio IS NULL)") do |x|
        true
      end
      can :manage, Actividad, Actividad.where("sector_id IN (SELECT sector_id FROM usuario_sectores WHERE admin_usuario_id=#{user.id})") do |x|
        true
      end
      can :manage, ActividadAlumno
      can :manage, ActividadOpcion
      can :manage, ActividadLista
      can :manage, ActividadArchivo
      can :manage, ActiveAdmin::Page, :name => "Ver_Actividad"
    end

    if user.inscripciones
      can :manage, InscripcionAlumno, InscripcionAlumno.where(
        "alumno_id IN (SELECT alumno_id FROM lista_alumnos WHERE lista_id IN (SELECT id FROM listas WHERE sector_id IN (SELECT sector_id FROM usuario_sectores WHERE admin_usuario_id=#{user.id}) AND anio=#{anio_pases}))"
        ) do |x|
        true
      end

      can :manage, Alumno
      can :manage, Persona
      can :manage, Inscripcion
      can :manage, ProximoGrado

      can :manage, Seguimiento
      can :manage, ActiveAdmin::Page, :name => "Seguimiento Cuenta"
      can :manage, Subgrado
    end
      
  end
end