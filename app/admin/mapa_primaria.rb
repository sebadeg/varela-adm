ActiveAdmin.register_page "Mapa_primaria" do

  menu priority: 50, label: "Primaria", parent: "Mapa"

  content do
   
    @markers = ""
  	i = 0
    Direccion.where("primaria").each do |x|
      @markers = @markers + "var marker#{i} = new google.maps.Marker({position: {lat: #{x.latitude}, lng: #{x.longitude}}, map: map});"
      i = i+1
    end

    render partial: 'mapa', locals: { markers: @markers }
  end

end