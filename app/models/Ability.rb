class Ability   
  include CanCan::Ability

  def initialize(user)
    puts "Usuario " + user.email

    can :manage, ActiveAdmin::Page, :name => "Dashboard"
    can :manage, ActiveAdmin::Comment
    
    if user.soporte
      can :manage, :all
    elsif user.primaria || user.sec_mdeo || user.sec_cc
      can :read, AdminUsuario, id: user.id 
      can :update, AdminUsuario, id: user.id 
      can :manage, Lista
    elsif user.administracion
      can :read, AdminUsuario, id: user.id 
      can :update, AdminUsuario, id: user.id 

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
    else
      can :read, AdminUsuario, id: user.id 
      can :update, AdminUsuario, id: user.id 

      can :manage, ActiveAdmin::Page, :name => "Importar" 
    end
      # if user.primaria
      #   can :manage, ActiveAdmin::Page, :name => "Primaria" 
      # elsif user.sec_mdeo
      #   can :manage, ActiveAdmin::Page, :name => "Pendiente" 
      # elsif user.sec_cc
      #   can :manage, ActiveAdmin::Page, :name => "Importar" 

#       can :read, ActiveAdmin::Page, :name => "Dashboard"

#       can :read, Usuario, id: user.id 
#       can :update, Usuario, id: user.id 

#       can :read, Alumno, Alumno.where(["(id IN (SELECT alumno_id FROM cuenta_alumnos INNER JOIN cuentas ON cuenta_alumnos.cuenta_id = cuentas.id AND usuario_id = ?)) OR (id IN (SELECT alumno_id FROM cuenta_alumnos INNER JOIN cuenta_usuarios ON cuenta_alumnos.cuenta_id = cuenta_usuarios.cuenta_id AND usuario_id = ?))",user.id, user.id]) do |x| 
#         true
#       end
#       can :update, Alumno, Alumno.where(["(id IN (SELECT alumno_id FROM cuenta_alumnos INNER JOIN cuentas ON cuenta_alumnos.cuenta_id = cuentas.id AND usuario_id = ?)) OR (id IN (SELECT alumno_id FROM cuenta_alumnos INNER JOIN cuenta_usuarios ON cuenta_alumnos.cuenta_id = cuenta_usuarios.cuenta_id AND usuario_id = ?))",user.id, user.id]) do |x| 
#         true
#       end

#       can :read, Cuenta, Cuenta.where(["usuario_id = ? OR (id IN (SELECT cuenta_id FROM cuenta_usuarios WHERE usuario_id = ?))",user.id, user.id]) do |x| 
#         true
#       end

#       can :read, CuentaUsuario, cuenta: { usuario: user }

#       can :read, CuentaAlumno, cuenta: { usuario: user }

#       #cuenta: { :cuenta_usuarios do |x| x.usuario_id == user.id end }
#       #   c.cuenta_id == :id
#       # end


#       #

# #    elsif user.has_role? :author
#       #can :create, Grado
#       #can :update, Grado
      
#       #can :create, Usuario
#       #can :update, Usuario
#       #can :destroy, Info

#       #can :read, ActiveAdmin::Page, name: "Dashboard", namespace_name: :admin
#       #can :read, :all
#       #can :read, :all
#    end
  end
end