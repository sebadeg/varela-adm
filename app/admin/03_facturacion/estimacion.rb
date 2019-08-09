ActiveAdmin.register_page "Estimación" do

  menu priority: 303, label: "Estimación", parent: "Facturación"

  content do
    render partial: 'estimacion'
  end

end