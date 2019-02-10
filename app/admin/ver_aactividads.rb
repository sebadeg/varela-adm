ActiveAdmin.register_page "Ver_Aactividad" do

  menu priority: 10000, label: "Ver actividad", parent: "Actividad 2019"

  page_action :ver, method: :post do
    p "//////////"
    p "Ver 2"
    p "//////////"
    p params

    Temp.create(usuario_id: current_admin_usuario.id, temp_id: params[:alumno_id] )

    redirect_to admin_ver_aactividad_path
    
    
  end

  content do
    temp = Temp.where("usuario_id = #{current_admin_usuario.id}").order(id: :desc).limit(1).first rescue nil

    p "++++++++++"
    p "++++++++++"
    p temp.temp_id
    p "++++++++++"
    p "++++++++++"


    if temp == nil 
      render partial: 'ver_aactividad'
    else
      render partial: 'ver_aactividad', locals: { alumno_id: temp.temp_id, usuario_id: temp.usuario_id }
    end
  end

end