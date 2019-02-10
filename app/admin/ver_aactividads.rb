ActiveAdmin.register_page "Ver_Aactividad" do

  menu priority: 10000, label: "Ver actividad", parent: "Actividad 2019"

  permit_params :alumno_id

  page_action :ver, method: :post do
    @alumno_id = params[:alumno_id]
    p @alumno_id
    redirect_to admin_ver_aactividad_path, id: params[:alumno_id], notice: "HECHO"
  end

  content do
    p "++++++++++"
    p "++++++++++"
    p params
    p "++++++++++"
    p "++++++++++"
    render partial: 'ver_aactividad', locals: { alumno_id: params[:id] }
  end

end