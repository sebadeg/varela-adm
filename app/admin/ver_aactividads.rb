ActiveAdmin.register_page "Ver_Aactividad" do

  menu priority: 10000, label: "Ver actividad", parent: "Actividad 2019"

  page_action :ver, method: :post do
      p "//////////"
      p "Ver 2"
      p "//////////"
    #redirect_to admin_ver_aactividad_path, notice: "HECHO"
  end

  controller do
    def index
      p "//////////"
      p "Index"
      p "//////////"
      p params

      #params[:alumno_id] = 121212
      #p params[:alumno2_id]

    end

      
    def ver
      p "//////////"
      p "Ver"
      p "//////////"
      p params

      redirect_to controller: 'index', action: 'get', id: params[:alumno_id]
    end

  end

  content do
    p "++++++++++"
    p "++++++++++"
    p params[:alumno_id]
    p "++++++++++"
    p "++++++++++"
    render partial: 'ver_aactividad', locals: { alumno_id: 121212, alumno2_id: params[:alumno_id] }
  end

end