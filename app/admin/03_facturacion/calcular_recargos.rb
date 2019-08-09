ActiveAdmin.register_page "Calcular_Recargo" do

  menu priority: 302, label: "Calcular Recargo", parent: "Facturación"

  page_action :ver, method: :post do
    redirect_to admin_calcular_recargo_path
  end

  content title: "Calcular Recargo" do
    render partial: 'calcular_recargo'
  end

end