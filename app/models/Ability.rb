class Ability   
  include CanCan::Ability



  def initialize(user)

    puts "Usuario " + user.email

    if user.soporte
      can :manage, :all
      return
    end

    can :manage, ActiveAdmin::Page, name: "Dashboard"
    can :manage, ActiveAdmin::Comment
    can :read, AdminUsuario, id: user.id 
    can :update, AdminUsuario, id: user.id      


    if user.administracion
      can :manage, Mov
      can :manage, Placta
      can :manage, Movimiento
      can :manage, Deudor

      can :manage, Recibo

      can :manage, Especial
      can :manage, Pago
      can :manage, ActiveAdmin::Page, :name => "Lote_pago"
      can :manage, PagoCuenta
      can :manage, Cuenta
      can :manage, Alumno
      can :manage, Tarea
      can :read, Usuario

      can :manage, Contrato
      can :read, InscripcionAlumno
      can :manage, Pase
      can :manage, Recargo

      can :manage, Inscripcion

      can :manage, Seguimiento
      can :manage, ActiveAdmin::Page, :name => "Seguimiento Cuenta"
      can :manage, Subgrado


      return
    end






    s = "0"
    if user.primaria || user.sec_mdeo || user.sec_cc
      if user.primaria
        s = s + ",1"
      end
      if user.sec_mdeo
        s = s + ",2"
      end
      if user.sec_cc
        s = s + ",3"
      end
    elsif user.inscripciones
      s = "0,1,2,3"
    end


    if user.primaria || user.sec_mdeo || user.sec_cc || user.inscripciones
      pases = Pase.where("alumno_id IN (SELECT alumno_id FROM lista_alumnos WHERE lista_id IN (SELECT id FROM listas WHERE sector_id IN (" + s + ") AND anio=2018))")
      can :read, Pase, pases do |x|
        true
      end
      can :update, Pase, pases do |x|
        true
      end

      can :manage, InscripcionAlumno, InscripcionAlumno.where(
        "alumno_id IN (SELECT alumno_id FROM lista_alumnos WHERE lista_id IN (SELECT id FROM listas WHERE sector_id IN (" + s + ") AND anio=2018))"
        ) do |x|
        true
      end

      can :manage, Seguimiento
      can :manage, ActiveAdmin::Page, :name => "Seguimiento Cuenta"
      can :manage, Subgrado
    end

    if user.primaria || user.sec_mdeo || user.sec_cc
      can :manage, Lista, Lista.where("sector_id IN (" + s + ") AND anio IN (SELECT anio FROM configs WHERE NOT anio IS NULL)") do |x|
        true
      end
      
      can :manage, Aactividad
      can :manage, AactividadAlumno
      can :manage, AactividadOpcion
      can :manage, AactividadLista
      can :manage, AactividadArchivo
      can :manage, ActiveAdmin::Page, :name => "Ver_Aactividad"
    end

    if user.inscripciones
      can :manage, Inscripcion
    end
      
  end
end