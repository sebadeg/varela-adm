class Ability   
  include CanCan::Ability



  def initialize(user)

    puts "Usuario " + user.email

    can :manage, ActiveAdmin::Page, name: "Dashboard"
    can :manage, ActiveAdmin::Comment
    
    if user.soporte
      can :manage, :all
    else
      can :read, AdminUsuario, id: user.id 
      can :update, AdminUsuario, id: user.id      


      if user.primaria || user.sec_mdeo || user.sec_cc
        s = ""
        if user.primaria
          s = "1"
        end
        if user.sec_mdeo
          if s != ""
            s = s + ","
          end
          s = s + "2"
        end
        if user.sec_cc
          if s != ""
            s = s + ","
          end
          s = s + "3"
        end

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

        can :manage, Lista, Lista.where("sector_id IN (" + s + ") AND anio IN (SELECT anio FROM configs WHERE NOT anio IS NULL)") do |x|
          true
        end
        can :manage, Inscripcion
        can :manage, Seguimiento
        can :manage, ActiveAdmin::Page, :name => "Seguimiento Cuenta"
        can :manage, Subgrado
      elsif user.inscripciones
        can :manage, Inscripcion
        can :manage, Seguimiento
        can :manage, ActiveAdmin::Page, :name => "Seguimiento Cuenta"
        can :manage, Subgrado
      elsif user.administracion
        can :manage, Mov
        can :manage, Placta
        can :manage, Movimiento

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
        can :manage, Inscripcion
        can :manage, Pase
        can :manage, Recargo
      end
    end
  end
end