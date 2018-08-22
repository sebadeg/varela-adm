ActiveAdmin.register InscripcionAlumno do
  menu label: 'Reinscripción Alumno', priority: 80 

  permit_params :cedula

  action_item :registrar, only: :show do
    link_to "Registrar", registrar_admin_inscripcion_alumno_path(inscripcion_alumno), method: :put 
  end

  member_action :registrar, method: :put do
    id = params[:id]
    inscripcion_alumno = InscripcionAlumno.find(id)

    ActiveRecord::Base.connection.execute( "UPDATE inscripcion_alumnos SET registrado=true WHERE id=#{id};" )

    redirect_to admin_inscripcion_alumno_path(inscripcion_alumno)
  end


  action_item :deshacer_registro, only: :show do
    link_to "Deshacer registro", deshacer_registro_admin_inscripcion_alumno_path(inscripcion_alumno), method: :put 
  end

  member_action :deshacer_registro, method: :put do
    id = params[:id]
    inscripcion_alumno = InscripcionAlumno.find(id)

    ActiveRecord::Base.connection.execute( "UPDATE inscripcion_alumnos SET registrado=false WHERE id=#{id};" )

    redirect_to admin_inscripcion_alumno_path(inscripcion_alumno)
  end

  index do
  	#selectable_column
    column :alumno_id
    column "Nombre" do |r| "#{r.alumno.nombre} #{r.alumno.apellido}" end
    column :cedula
    column :registrado
    actions
  end

  filter :alumno_id
  filter :cedula
  filter :registrado

  show do
    attributes_table do
      row :alumno_id
      row "Nombre" do |r| "#{r.alumno.nombre} #{r.alumno.apellido}" end
      row :cedula
      row "Grado" do |r| ( (g = ProximoGrado.find(r.grado)) != nil ? "#{g.nombre} - $U #{g.precio}" : "") end
      row "Convenio" do |r| (r.convenio != nil ? "#{r.convenio.nombre} - #{r.convenio.valor} %" : "") end
      row :matricula
      row :hermanos
      row :cuotas
      row :nombre1
      row :documento1
      row :domicilio1
      row :email1
      row :celular1
      row :nombre2
      row :documento2
      row :domicilio2
      row :email2
      row :celular2
      row :registrado
    end
  end

  form do |f|
    f.inputs do
      f.input :alumno_id
      f.input :cedula
      # f.has_many :cuenta_alumno, heading: "Cuentas" do |ca|
      #   ca.input :cuenta_id, :label => 'Cuenta', :as => :select, :collection => Cuenta.all.map{|u| ["#{u.numero}", u.id]}
      # 	ca.input :numero
      # end
    end
    f.actions
  end

end
