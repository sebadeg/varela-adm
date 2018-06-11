ActiveAdmin.register_page "Importar" do

  menu priority: 4, label: "Importar"

  content do
    render partial: 'importar'
  end

  page_action :importar, method: :post do
    result = Archivo.importar(params[:archivos])
    redirect_to admin_importar_path, notice: result
  end

  page_action :exportar, method: :post do
    result = Archivo.exportar()
    redirect_to admin_importar_path, notice: result
  end

end