ActiveAdmin.register_page "Ver_Aactividad" do

  menu priority: 10000, label: "Ver actividad", parent: "Actividad 2019"

  page_action :ver, method: :post do  
    redirect_to admin_ver_aactividad_path, notice: "HECHO"
  end

  controller do
    def ver
      @alumno_id = params[:alumno_id])      
    end
  end

  content do
    render partial: 'ver_aactividad', locals: { alumno_id: @alumno_id }
  end

end