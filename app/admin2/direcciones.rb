ActiveAdmin.register Direccion do
  menu label: 'Direcciones', priority: 22 

  permit_params :id, :direccion, :resultado, :latitude, :longitude


  action_item :localizar, only: :show do
    link_to "Localizar", localizar_admin_direccion_path(direccion), method: :put 
  end

  member_action :localizar, method: :put do
    id = params[:id]
    x = Direccion.find(id)

     results = Geocoder.search(x.direccion)

      x.resultado = ""
      x.latitude = 0
      x.longitude = 0
      if results != nil && results.first != nil
         x.resultado = results.first.formatted_address
         x.latitude = results.first.latitude
         x.longitude = results.first.longitude
      end
      x.save!

    redirect_to admin_direccion_path(x)
  end


  index do
  	#selectable_column
    column :id
    column :direccion
    column :resultado
    column :latitude
    column :longitude

    actions
  end

  show do
    attributes_table do
      row :id
      row :direccion
      row :resultado
      row :latitude
      row :longitude
    end
  end

  form do |f|
    f.inputs do
      f.input :id
      f.input :direccion
      f.input :resultado
      f.input :latitude
      f.input :longitude
    end
    f.actions
  end

end
