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
 
      row "Alumnos" do |r|
        table_for Alumno.where("id in (SELECT alumno_id FROM subgrado_alumnos WHERE subgrado_id=#{r.id})").order(:nombre, :apellido) do |t|
          t.column :id
          t.column :nombre
          t.column :apellido

          t.column "Registrado" do |x| (InscripcionAlumno.where( "alumno_id=#{x.id}" ).registrado) end
          t.column "Inscripto" do |x| (InscripcionAlumno.where( "alumno_id=#{x.id}" ).inscripto) end

        end
      end

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