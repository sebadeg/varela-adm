ActiveAdmin.register_page "Informe" do

  menu priority: 1, label: "Informe", parent: "Inscripción"

  content do
    form decorate: true do |f|
      table_for ActiveRecord::Base.connection.execute("SELECT *,proximo_grados.id as grado1 FROM inscripcion_alumnos INNER JOIN proximo_grados ON inscripcion_alumnos.grado=proximo_grados.id WHERE registrado ORDER BY proximo_grados.nombre"), sortable: true, class: 'index_table' do
        column "Alumno" do |x| x["alumno_id"] end
        column "Nombre" do |x| (alumno = Alumno.find(x["alumno_id"])) != nil ? "#{alumno.nombre} #{alumno.apellido}" : "" end
        column "Grado" do |x| ProximoGrado.find(x["grado1"]).nombre end
        column "Inscripto" do |x| x["inscripto"] end
      end
    end
  end

  sidebar "Filtros" do
    div do
      render "search_user"
    end
  end
end
