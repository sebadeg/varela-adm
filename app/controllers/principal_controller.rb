class PrincipalController < ApplicationController
  def index
  	@markers = ""
  	i = 0
    Direccion.all.each do |x|

      if x.latitude > -35 && x.latitude < -34.5 && x.longitude > -56.6 && x.longitude < -55.5
        @markers = @markers + "var marker#{i} = new google.maps.Marker({position: {lat: #{x.latitude}, lng: #{x.longitude}}, map: map});"
        i = i+1
      end
    end
    p @markers
  end
end
