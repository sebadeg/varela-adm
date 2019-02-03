ActiveAdmin.register InscripcionAlumno, as: 'Pase' do

  menu label: 'Pases'

  permit_params :fecha_pase, :destino

  index do
  	#selectable_column
    column :alumno_id
    column "Nombre" do |c| 
      if c.alumno != nil
        c.alumno.nombre
      end
    end
    column "Apellido" do |c| 
      if c.alumno != nil
        c.alumno.apellido
      end
    end
    column :fecha_pase
    column :destino
    actions
  end

  filter :alumno_id, :label => 'Alumno', :as => :select, :collection => Alumno.where("IN (SELECT alumno_id FROM lista_alumnos WHERE lista_id IN (SELECT id FROM listas WHERE sector_id IN (" + sector() + ") AND anio IN (SELECT anio FROM configs WHERE NOT anio IS NULL)))").order(:nombre,:apellido).map{|u| ["#{u.id} - #{u.nombre} #{u.apellido}", u.id]}

  show do
    attributes_table do
      row :fecha_pase
      row :destino
    end
  end

  form do |f|
    f.inputs do      
      f.input :fecha_pase
      f.input :destino
    end
    f.actions
  end

  controller do

    def sector
      s = ""
      if current_admin_usuario.primaria
        s = "1"
      end
      if current_admin_usuario.sec_mdeo
        if s != ""
          s = s + ","
        end
        s = s + "2"
      end
      if current_admin_usuario.sec_cc
        if s != ""
          s = s + ","
        end
        s = s + "3"
      end
      return s
    end

    def show
      @page_title = "Pases"
      if resource != nil
        @page_title = "Pase de : #{resource.alumno_id}"
        a = Alumno.find(resource.alumno_id) rescue nil
        if a != nil
          @page_title = @page_title + " - #{a.nombre} #{a.apellido}"
        end
      end
    end

    def edit
      @page_title = "Pases"
      if resource != nil
        @page_title = "Pase de : #{resource.alumno_id}"
        a = Alumno.find(resource.alumno_id) rescue nil
        if a != nil
          @page_title = @page_title + " - #{a.nombre} #{a.apellido}"
        end
      end
    end

  end  

end
