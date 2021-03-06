ActiveAdmin.register Mov do

  menu priority: 1101, label: "Movimientos", parent: "Kaldor"

  index do
  	#selectable_column

    column "Fecha", :movfec
    column "Cuenta" do |r| (r.placta != nil ? "#{r.placta.plagru}-#{r.placta.placap}-#{r.placta.plarub}-#{r.placta.plasub}" : "") end
    column "Subcuenta", :movcta
    column "Descripción", :movdes
    column "Com", :movcom
    column "Código", :movcod
    column "Debe", :movdeb
    column "Haber", :movhab
  end

  filter :movfec
  filter :movcta

end
