ActiveAdmin.register_page "Ver_Aactividad" do

  menu priority: 10000, label: "Ver actividad", parent: "Actividad 2019"

  page_action :ver, method: :post do  	
   	#@alumno_id = eval(params[:alumno])
    redirect_to admin_aactividad_path, notice: "HECHO"
  end

  content do
    render partial: 'aactividad'

    # , locals:
    # {
    #   alumno_id: @alumno_id
    # }
  end

end