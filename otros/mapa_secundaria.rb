ActiveAdmin.register_page "Mapa_secundaria" do

  menu priority: 1208, label: "Secundaria Montevideo", parent: "Mapa"

  content do
   
    @markers = ""
  	i = 0
    Direccion.where("secundaria").each do |x|
      @markers = @markers + "var marker#{i} = new google.maps.Marker({position: {lat: #{x.latitude}, lng: #{x.longitude}}, map: map});"
      i = i+1
    end

    render partial: 'mapa', locals: { markers: @markers }
  end

end