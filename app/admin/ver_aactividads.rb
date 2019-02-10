ActiveAdmin.register_page "Ver_Aactividad" do

  menu priority: 10000, label: "Ver actividad", parent: "Actividad 2019"

  page_action :ver, method: :post do
    @alumno_id = params[:alumno_id]
    p @alumno_id
    redirect_to admin_ver_aactividad_path, notice: "HECHO"
  end

  content do
    p "++++++++++"
    p "++++++++++"
    p params
    p "++++++++++"
    p "++++++++++"
    render partial: 'ver_aactividad', locals: { alumno_id: @alumno_id }
  end

end