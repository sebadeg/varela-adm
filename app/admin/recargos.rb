ActiveAdmin.register Recargo do

  permit_params :cuenta_id, :fecha_comienzo, :fecha_fin, :comentario

  menu label: 'Recargos'
  menu parent: 'Cuenta Corriente'

  index do
  	#selectable_column

    column "Cuenta" do |c| 
      if c.cuenta != nil
        c.cuenta.id.to_s + " - " + c.cuenta.nombre 
      end
    end
    column "Comienzo", :fecha_comienzo
    column "Fin", :fecha_fin
    actions
  end

  filter :cuenta_id
  filter :fecha_comienzo
  filter :fecha_fin

  show do
    attributes_table do
      row "Cuenta" do |r| (r.cuenta != nil ? "#{r.cuenta.id} - #{r.cuenta.nombre}" : "") end
      row "Comienzo" do |r| r.fecha_comienzo end
      row "Fin" do |r| r.fecha_fin end
      row :comentario
    end
  end

  form do |f|
    f.inputs do
      f.input :cuenta_id, :label => 'Cuenta', :as => :select, :collection => Cuenta.all.order(:id).map{|u| ["#{u.id}",u.id]}
      f.input :comentario, as: :text
      f.input :fecha_comienzo, as: :date_picker
      f.input :fecha_fin, as: :date_picker
    end
    f.actions
  end


end
