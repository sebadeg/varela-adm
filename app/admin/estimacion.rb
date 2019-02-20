ActiveAdmin.register_page "Estimacion" do

  menu priority: 70, label: "Estimación"
  menu parent: 'Facturación'

  content do
    render partial: 'estimacion'
  end

end