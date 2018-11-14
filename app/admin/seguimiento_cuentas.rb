ActiveAdmin.register_page "Seguimiento Cuenta" do

  menu label: 'Seguimiento Cuenta'
  menu parent: 'Seguimiento'

  content do
    columns do
      column do
        panel "Cuentas" do
          table_for Alumno.where("id IN (SELECT alumno_id FROM cuenta_alumnos WHERE cuenta_id=#{params[:cuenta]})").each do |c|
            column :id
            column :nombre
            column :apellido
            column "Seguimiento" do |x|
              link_to 'Seguimiento', admin_cuenta_path(x), method: :get
            end
          end
        end
      end

    end
  end

end
