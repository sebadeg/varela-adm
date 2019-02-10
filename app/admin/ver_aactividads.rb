ActiveAdmin.register_page "Ver_Aactividad" do

  menu priority: 10000, label: "Ver actividad", parent: "Actividad 2019"

  page_action :ver, method: :post do
    p "//////////"
    p "Ver 2"
    p "//////////"
    #redirect_to admin_ver_aactividad_path, alumno_id: 121212
    redirect_to admin_ver_aactividad_path, action: 'get', options: {alumno_id: 121212} 
  end

  content do
    p "++++++++++"
    p "++++++++++"
    p params[:alumno_id]
    p options
    p "++++++++++"
    p "++++++++++"
    render partial: 'ver_aactividad', locals: { alumno_id: params[:alumno_id] }
  end

end