ActiveAdmin.register_page "Seguimiento Cuenta" do

  menu label: 'Seguimiento Cuenta'
  menu parent: 'Seguimiento'

  content do
    columns do
      column do
        panel "Alumnos" do
          table_for Alumno.where("id IN (SELECT alumno_id FROM cuenta_alumnos WHERE cuenta_id=#{params[:cuenta]})").each do |c|
            column :id
            column :nombre
            column :apellido

            column "Habilitado" do |x| (InscripcionAlumno.where( "alumno_id=#{x.id}" ).first rescue nil) != nil ? !InscripcionAlumno.where( "alumno_id=#{x.id}" ).first.inhabilitado : "" end

            column "Registrado" do |x| (InscripcionAlumno.where( "alumno_id=#{x.id}" ).first rescue nil) != nil ? InscripcionAlumno.where( "alumno_id=#{x.id}" ).first.registrado : "" end
            column "Inscripto" do |x| (InscripcionAlumno.where( "alumno_id=#{x.id}" ).first rescue nil) != nil ? InscripcionAlumno.where( "alumno_id=#{x.id}" ).first.inscripto : "" end


            column "Seguimiento" do |x|
              link_to 'Seguimiento', admin_alumno_path(x), method: :get
            end
          end
        end
      end

    end
  end

end
