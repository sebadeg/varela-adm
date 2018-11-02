class PrincipalController < ApplicationController
  def index
  	@markers = ""
  	i = 0
    Direccion.all.each do |x|

      #if x.latitude > -35 && x.latitude < -34.5 && x.longitude > -56.4 && x.longitude < -55.5
        @markers = @markers + "var marker#{i} = new google.maps.Marker({position: {lat: #{x.latitude}, lng: #{x.longitude}}, map: map});"
        i = i+1
  #     else

  #       results = Geocoder.search(x.direccion + ",Montevideo,Uruguay")
  #       x.resultado = ""
  #       x.latitude = 0
  #       x.longitude = 0
  #       if results != nil && results.first != nil
  #         x.resultado = results.first.formatted_address
  #         #if x.latitude > -35 && x.latitude < -34.5 && x.longitude > -56.6 && x.longitude < -55.5
  #           x.latitude = results.first.latitude
  #           x.longitude = results.first.longitude
		#   #end
		# end
		# x.save!

      #end
    end
    p @markers
  end
end
