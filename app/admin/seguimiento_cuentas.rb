ActiveAdmin.register_page "Seguimiento Cuenta" do

  menu label: 'Seguimiento Cuenta'
  menu parent: 'Seguimiento'

  content do
    columns do
      column do
        panel "Cuentas" do
          ul do
            Cuenta.all do |c|
              li link_to "Habilitar", admin_cuenta_path(c), method: :get 
            end
          end
        end
      end
    end
  end

end
