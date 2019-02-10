ActiveAdmin.register_page "Aactividad" do

  menu priority: 10000, label: "Vista previa", parent: "Actividad 2019"

  page_action :ver, method: :post do  	
   	@alumno_id = eval(params[:alumno])
    redirect_to admin_aactividad_path, notice: @alumno_id.to_s
  end

  content do
    render partial: 'aactividad', locals:
    {
      alumno_id: @alumno_id
    }
  end

end