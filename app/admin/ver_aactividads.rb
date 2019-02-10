ActiveAdmin.register_page "Ver_Aactividad" do

  menu priority: 10000, label: "Ver actividad", parent: "Actividad 2019"

  page_action :ver, method: :post do
    @alumno_id: params[:alumno_id]
    redirect_to action: admin_ver_aactividad_path, notice: "HECHO"
  end

  content do
    render partial: 'ver_aactividad', locals: { alumno_id: @arbre_context.assigns[:alumno_id] }
  end

end