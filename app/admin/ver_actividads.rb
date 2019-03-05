ActiveAdmin.register_page "Ver_Actividad" do

  menu priority: 3, label: "Vista previa de actividad", parent: "Secretaría"

  page_action :descargar, method: :post do
    p "//////////"
    p "Descargar"
    p params
    p "//////////"

    # p params[:id]

    actividad = Actividad.find(params[:id])
    if ( actividad != nil )
      file_name = "#{actividad.nombre}.pdf"
      file = Tempfile.new(file_name)
      

      pdf = CombinePDF.new
      ActividadArchivo.where("actividad_id=#{params[:id]}").order(:id).each do |arch|
        
        file2_name = "#{arch.nombre}"
        file2 = Tempfile.new(file2_name)
        IO.binwrite(file2.path, arch.data)
        pdf << CombinePDF.load(file2.path)

      end
      pdf.save file.path

      send_file(
        file.path,
        filename: file_name,
        type: "application/pdf"
      )
    else
      redirect_to admin_ver_actividad_path
    end
  end

  page_action :confirmar, method: :post do
    p "//////////"
    p "Confirmar"
    p params
    p "//////////"
    redirect_to admin_ver_actividad_path
  end

  page_action :ver, method: :post do
    Temp.create(usuario_id: current_admin_usuario.id, temp_id: params[:alumno_id] )
    redirect_to admin_ver_actividad_path
  end

  content title: "Vista previa" do
    temp = Temp.where("usuario_id = #{current_admin_usuario.id}").order(id: :desc).limit(1).first rescue nil
    if temp == nil 
      render partial: 'ver_actividad', locals: { alumno_id: nil, usuario_id: current_admin_usuario.id }
    else
      render partial: 'ver_actividad', locals: { alumno_id: temp.temp_id, usuario_id: current_admin_usuario.id }
    end
  end

end