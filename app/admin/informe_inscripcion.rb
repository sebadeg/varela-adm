ActiveAdmin.register_page "Informe" do

  menu priority: 1, label: "Informe", parent: "Inscripción"

  content do
    collection = ActiveRecord::Base.connection.execute(
        "SELECT * FROM
        ((SELECT alumnos.id as alumno1, alumnos.nombre || ' ' || alumnos.apellido as alumnonombre1, proximo_grados.id as grado1 , proximo_grados.nombre as gradonombre1, inscripcion_alumnos.inscripto AS inscripto1
        FROM alumnos INNER JOIN inscripcion_alumnos ON alumnos.id=inscripcion_alumnos.alumno_id INNER JOIN proximo_grados ON inscripcion_alumnos.grado=proximo_grados.id
        WHERE registrado)
        UNION
        (SELECT null as alumno1, inscripciones.nombre as alumnonombre1, proximo_grado_id as grado1 , proximo_grados.nombre as gradonombre1, true AS inscripto1
        FROM inscripciones INNER JOIN proximo_grados ON inscripciones.proximo_grado_id=proximo_grados.id)) AS foo
        ORDER BY foo.gradonombre1" 
         #LIMIT #{30} OFFSET #{30*(params[:page] == nil ? 0 : params[:page])}"
         )

    table_for collection, sortable: true, class: 'index_table' do
      column "Alumno" do |x| x["alumno1"] end
      column "Nombre" do |x| x["alumnonombre1"] end
      column "Grado" do |x| x["gradonombre1"] end
      column "Inscripto" do |x| x["inscripto1"] end
    end

    div do 
      collection.count
    end


  end

  sidebar "Filtros" do
    div do
      render "search_user"
    end
  end

end
