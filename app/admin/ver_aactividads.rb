ActiveAdmin.register_page "Ver_Aactividad" do

  menu priority: 10000, label: "Ver actividad", parent: "Actividad 2019"

  page_action :ver, method: :post do
    @alumno_id: params[:alumno_id]
    render partial: 'ver_aactividad', locals: { alumno_id: @alumno_id }
  end

  content do
    render partial: 'ver_aactividad'
  end

end