ActiveAdmin.register CuotaSocio do

  menu label: "Cuotas", priority: 2, parent: "SUE" 

  permit_params :id, :socio_id, :fecha, :concepto, :importe

  index do
  	#selectable_column
 
    column "Socio" do |r| (r.socio != nil ? "#{r.socio.nombre} #{r.socio.apellido}" : "" ) end
    column :fecha
    column :concepto
    column :importe

    actions
  end

  filter :nombre
  filter :apellido

  show do
    attributes_table do
      row "Socio" do |r| (r.socio != nil ? "#{r.socio.nombre} #{r.socio.apellido}" : "" ) end
      row :socio_id
      row :fecha
      row :concepto
      row :importe
    end
  end

  form do |f|
    f.inputs do
      f.input :socio_id, :label => 'Socio', :as => :select, :collection => Socio.all.order(:nombre,:apellido).map{|u| ["#{u.nombre} #{u.apellido}",u.id]}
      f.input :fecha
      f.input :concepto
      f.input :importe
    end
    f.actions
  end

end
