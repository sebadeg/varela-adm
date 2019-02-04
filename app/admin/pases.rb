ActiveAdmin.register InscripcionAlumno, as: 'Pase' do

  menu label: 'Pases'

  permit_params :id, :alumno_id, :fecha_pase, :destino

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

  filter :alumno_id, :label => 'Alumno', :as => :select, :collection => Alumno.all.order(:nombre,:apellido).map{|u| ["#{u.id} - #{u.nombre} #{u.apellido}", u.id]}

  show do
    attributes_table do
      row :fecha_pase
      row :destino
    end
  end

  form do |f|
    f.inputs do      
      f.input :id, as: :hidden
      f.input :alumno_id, as: :hidden
      f.input :fecha_pase
      f.input :destino
    end
    f.actions
  end

  # controller do    

  #   def show
  #     @page_title = "Pases"
  #     if resource != nil
  #       @page_title = "Pase de : #{resource.alumno_id}"
  #       a = Alumno.find(resource.alumno_id) rescue nil
  #       if a != nil
  #         @page_title = @page_title + " - #{a.nombre} #{a.apellido}"
  #       end
  #     end
  #   end

  #   def edit
  #     @page_title = "Pases"
  #     if resource != nil
  #       @page_title = "Pase de : #{resource.alumno_id}"
  #       a = Alumno.find(resource.alumno_id) rescue nil
  #       if a != nil
  #         @page_title = @page_title + " - #{a.nombre} #{a.apellido}"
  #       end
  #     end
  #   end

  #   def update
  #     update! do |format|
  #       format.html { redirect_to collection_path } if resource.valid?
  #     end
  #   end

  #   def create
  #     create! do |format|
  #       format.html { redirect_to collection_path } if resource.valid?
  #     end
  #   end

  # end  

end
