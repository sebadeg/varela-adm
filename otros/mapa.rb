ActiveAdmin.register_page "Mapa" do

  menu priority: 1205, label: "Mapa"

  content do
   
    @markers = ""
  	i = 0
    Direccion.all.each do |x|
      @markers = @markers + "var marker#{i} = new google.maps.Marker({position: {lat: #{x.latitude}, lng: #{x.longitude}}, map: map});"
      i = i+1
    end

    render partial: 'mapa', locals: { markers: @markers }
  end

end