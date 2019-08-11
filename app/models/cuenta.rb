class Cuenta < ApplicationRecord
  has_many :pago_cuenta
  has_many :recargo

  scope :todos, -> { all }
  scope :concurre, -> { where("concurre") }
  scope :brou, -> { where("brou") }
  scope :visa, -> { where("visa") }
  scope :oca, -> { where("oca") }

  def titular_mail
  	s = ""
  	TitularCuenta.where("cuenta_id=#{id}").each do |tc|
      Usuario.where("id=#{tc.usuario_id}").each do |u|
      	if u.email != nil
          if s != ""
        	  s = s + ","
        	end
        	s = s + u.email      	
        end
      end	
  	end
  	return s
  end

  def titular_celular
  	s = ""
  	TitularCuenta.where("cuenta_id=#{id}").each do |tc|
      Usuario.where("id=#{tc.usuario_id}").each do |u|
        if u.celular != nil
        	if s != ""
        	  s = s + ","
        	end
        	s = s + u.celular      	
        end	
      end
  	end
  	return s
  end

end
