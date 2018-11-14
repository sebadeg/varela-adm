ActiveAdmin.register_page "Seguimiento Cuenta" do

  menu label: 'Seguimiento Cuenta'
  menu parent: 'Seguimiento'

  content do
    columns do
      column do
        panel "Cuentas" do
          ul do
            Cuenta.all.each do |c|
              li link_to "Seguimiento", admin_cuenta_path(c), method: :get 
            end
          end
        end
      end

      column do
        panel "Cuentas" do
          table_for Cuenta.all.each do |c|
            :id
            actions defaults: false do |u|
              item "Seguimiento", admin_cuenta_path(u), title: "Seguimiento"
            end
          end
        end
      end

    end
  end

end
