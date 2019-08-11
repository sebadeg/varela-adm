ActiveAdmin.register_page "Primaria" do

  menu false  
  #menu priority: 1209, label: "Primaria", parent: 'Otros'

  content do
    render partial: 'primaria'
  end

end