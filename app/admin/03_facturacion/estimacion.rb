ActiveAdmin.register_page "Estimación" do

  menu priority: 302, label: "Estimación", parent: "Facturación"

  content do
    render partial: 'estimacion'
  end

end