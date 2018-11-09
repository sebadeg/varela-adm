ActiveAdmin.register Subgrado do

  menu label: 'Grados'
  menu parent: 'Inscripciones'

  permit_params :id, :nombre, :apellido

  # permit_params do
  #   params = [:direccion]
  #   params.push [:nombre,:cedula] if current_usuario.admin?
  #   params
  # end


  index do
  	#selectable_column
    column :id
    column :nombre
    column "Grado" do |r| (r.grado != nil ? "#{r.grado.nombre} (#{r.grado.anio})" : "") end

    actions
  end

  filter :nombre

  show do
    attributes_table do
      row :id
      row :nombre
      row "Grado" do |r| (r.grado != nil ? "#{r.grado.nombre} (#{r.grado.anio})" : "") end
    end
  end

  form do |f|
    f.inputs do
      f.input :id
      f.input :nombre
      f.input :grado_id, :label => 'Grado', :as => :select, :collection => Grado.all.order(:anio,:nombre).map{|u| ["#{u.nombre (u.anio)}",u.id]}
    end
    f.actions
  end

end
