ActiveAdmin.register_page "Prueba" do

  menu false  
  #menu priority: 1211, label: "Prueba", parent: 'Otros'

  content do
    render partial: 'prueba'
  end

end