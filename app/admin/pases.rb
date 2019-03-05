ActiveAdmin.register Pase do

  menu priority: 4, label: "Pases", parent: "Secretaría"

  permit_params :fecha, :destino

  scope :todos 
  scope :pases

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
    column "Grado" do |r| Alumno.grado(r.alumno_id) end


    column :fecha
    column :destino
    actions
  end

  filter :alumno_id, :label => 'Alumno', :as => :select, :collection => Alumno.all.order(:nombre,:apellido).map{|u| ["#{u.id} - #{u.nombre} #{u.apellido}", u.id]}

  show do
    attributes_table do
      row :fecha
      row :destino
    end
  end

  form do |f|
    f.inputs do      
      f.input :fecha
      f.input :destino
    end
    f.actions
  end

  controller do    

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
