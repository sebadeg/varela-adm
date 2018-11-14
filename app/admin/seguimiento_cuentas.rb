ActiveAdmin.register_page "Seguimiento Cuenta" do

  menu label: 'Seguimiento Cuenta'
  menu parent: 'Seguimiento'

  content do
    columns do
      column do
        panel "Cuentas" do
          ul do
            Cuenta.all.each do |c|
              li link_to('Seguimiento',admin_cuenta_path(u))
            end
          end
        end
      end

      column do
        panel "Cuentas" do
          table_for Cuenta.all.each do |c|
            column :id
            column "Seguimiento" do
              link_to('Seguimiento',admin_cuenta_path(u))
            end
          end
        end
      end

    end
  end

end
