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
      
      @some_var = 121212
      #@some_var = @alumno_id
    end

      
    def ver
      p "//////////"
      p "Ver"
      p "//////////"
      @alumno_id = params[:alumno_id]
      p @alumno_id

      @some_var = 121212
      redirect_to admin_ver_aactividad_path, notice: "HECHO"
    end

  end

  content do
    p "++++++++++"
    p "++++++++++"
    p params
    p "++++++++++"
    p "++++++++++"
    render partial: 'ver_aactividad', locals: { alumno_id: @some_var }
  end

end