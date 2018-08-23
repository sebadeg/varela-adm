ActiveAdmin.register Inscripcion do
  menu label: 'Inscripción', priority: 90 

  permit_params :nombre,:apellido,:cedula,:proximo_grado_id,:convenio_id,:matricula,:hermanos,:cuotas,:nombre1,:documento1,:domicilio1,:email1,:celular1,:nombre2,:documento2,:domicilio2,:email2,:celular2

  action_item :formulario, only: :show do
    link_to "Formulario", formulario_admin_inscripcion_path(inscripcion), method: :put 
  end

  member_action :formulario, method: :put do
    id = params[:id]
    inscripcion = Inscripcion.find(id)



    redirect_to admin_inscripcion_path(inscripcion)
  end


  index do
  	#selectable_column
    column :nombre
    column :cedula
    actions
  end

  filter :nombre
  filter :cedula


  show do

    def find(arr,v)
      arr.each do |a|
        if a[1]==v
          return a[0]
        end
      end
      return ""
    end

    attributes_table title:"Alumno" do
      row :nombre
      row :cedula
      row "Grado" do |r| (r.proximo_grado != nil ? "#{r.proximo_grado.nombre} - $U #{r.proximo_grado.precio}" : "") end      
      row "Convenio" do |r| (r.convenio != nil ? "#{r.convenio.nombre} - #{r.convenio.valor} %" : "") end
      row "Matrícula" do |r| find([["Contado",5],["Exhonerada",6]],r.matricula) end
      row "Hermanos" do |r| find([["Sin hermanos",0],["1 hermano - 5%",1],["2 hermanos - 10%",2]],r.hermanos) end
      row :cuotas
    end

    attributes_table title:"Titular 1" do
      row :nombre1
      row :documento1
      row :domicilio1
      row :email1
      row :celular1
    end

    attributes_table title:"Titular 2" do
      row :nombre2
      row :documento2
      row :domicilio2
      row :email2
      row :celular2
    end
  end

  form do |f|
    f.inputs "Alumno" do
      f.input :nombre, label: "Nombre"
      f.input :cedula, label: "Cédula"
      f.input :proximo_grado_id, :label => 'Grado', :as => :select, :collection => ProximoGrado.all.order(:nombre).map{|c| ["#{c.nombre} - $U #{c.precio}", c.id]}
      f.input :convenio_id, :label => 'Convenio', :as => :select, :collection => Convenio.all.order(:nombre).map{|c| ["#{c.nombre} - #{c.valor} %", c.id]}
      f.input :matricula, :label => 'Matrícula', :as => :select, :collection => [["Contado",5],["Exhonerada",6]]
      f.input :hermanos, :label => 'Hermanos', :as => :select, :collection => [["Sin hermanos",0],["1 hermano - 5%",1],["2 hermanos - 10%",2]] 
      f.input :cuotas
    end
    f.inputs "Titular 1" do
      f.input :nombre1, label: "Nombre"
      f.input :documento1, label: "Cédula"
      f.input :domicilio1, label: "Domicilio"
      f.input :email1, label: "Mail"
      f.input :celular1, label: "Celular"
    end
    f.inputs "Titular 2" do
      f.input :nombre2, label: "Nombre"
      f.input :documento2, label: "Cédula"
      f.input :domicilio2, label: "Domicilio"
      f.input :email2, label: "Mail"
      f.input :celular2, label: "Celular"
    end
    f.actions
  end

end
