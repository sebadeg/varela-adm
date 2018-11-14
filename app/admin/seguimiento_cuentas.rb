ActiveAdmin.register_page "Seguimiento Cuenta" do

  menu label: 'Seguimiento Cuenta'
  menu parent: 'Seguimiento'

  content do
    columns do
      column do
        panel "Cuentas" do
          table_for Cuenta.where('id=12121').each do |c|
            column :id
            column "Seguimiento" do
              link_to('Seguimiento',admin_cuenta_path(c))
            end
          end
        end
      end

    end
  end

end
