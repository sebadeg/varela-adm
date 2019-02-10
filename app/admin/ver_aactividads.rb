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
    a_id = Temp.where("usuario_id = current_admin_usuario.id").order(id: :desc).limit(1).first rescue nil

    p "++++++++++"
    p "++++++++++"
    p a_id
    p "++++++++++"
    p "++++++++++"



    render partial: 'ver_aactividad', locals: { alumno_id: a_id }
  end

end