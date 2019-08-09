ActiveAdmin.register_page "Mapa_costa" do

  menu priority: 1206, label: "Secundaria Costa", parent: "Mapa"

  content do
   
    @markers = ""
  	i = 0
    Direccion.where("costa").each do |x|
      @markers = @markers + "var marker#{i} = new google.maps.Marker({position: {lat: #{x.latitude}, lng: #{x.longitude}}, map: map});"
      i = i+1
    end

    render partial: 'mapa', locals: { markers: @markers }
  end

end