ActiveAdmin.register InscripcionAlumno do
  menu label: 'Reinscripción Alumno', priority: 90 

  permit_params :nombre,:apellido,:cedula,:proximo_grado_id,:convenio_id,:matricula,:hermanos,:cuotas,:nombre1,:documento1,:domicilio1,:email1,:celular1,:nombre2,:documento2,:domicilio2,:email2,:celular2

  index do
  	#selectable_column
    column :nombre
    column :apellido
    column :cedula
    actions
  end

  filter :nombre
  filter :apellido
  filter :cedula

  show do
    attributes_table do
      row :nombre
      row :apellido
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
    end
  end

  form do |f|
    f.inputs do
      f.input :nombre
      f.input :apellido
      f.input :cedula
      f.input :proximo_grado_id
      f.input :convenio_id
      f.input :matricula
      f.input :hermanos
      f.input :cuotas
      f.input :nombre1
      f.input :documento1
      f.input :domicilio1
      f.input :email1
      f.input :celular1
      f.input :nombre2
      f.input :documento2
      f.input :domicilio2
      f.input :email2
      f.input :celular2
    end
    f.actions
  end

end
