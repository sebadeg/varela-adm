ActiveAdmin.register_page "Ver_Aactividad" do

  menu priority: 3002, label: "Vista previa", parent: "Actividad 2019"

  page_action :descargar, method: :post do
    p "//////////"
    p "Descargar"
    p params
    p "//////////"
    redirect_to admin_ver_aactividad_path
  end

  page_action :confirmar, method: :post do
    p "//////////"
    p "Confirmar"
    p params
    p "//////////"
    redirect_to admin_ver_aactividad_path
  end

  page_action :ver, method: :post do
    Temp.create(usuario_id: current_admin_usuario.id, temp_id: params[:alumno_id] )
    redirect_to admin_ver_aactividad_path
  end

  content title: "Vista previa" do
    temp = Temp.where("usuario_id = #{current_admin_usuario.id}").order(id: :desc).limit(1).first rescue nil
    if temp == nil 
      render partial: 'ver_aactividad', locals: { alumno_id: nil, usuario_id: current_admin_usuario.id }
    else
      render partial: 'ver_aactividad', locals: { alumno_id: temp.temp_id, usuario_id: current_admin_usuario.id }
    end
  end

end