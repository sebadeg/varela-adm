class Cuenta < ApplicationRecord
  has_many :titular_cuenta, :dependent => :delete_all
  accepts_nested_attributes_for :titular_cuenta, allow_destroy: true

  has_many :cuenta_alumno, :dependent => :delete_all
  accepts_nested_attributes_for :cuenta_alumno, allow_destroy: true

  has_many :factura, :dependent => :delete_all
  accepts_nested_attributes_for :factura, allow_destroy: true

  has_many :pago_cuenta
  has_many :recargo

  scope :todos, -> { all }
  scope :concurre, -> { where("concurre") }
  scope :brou, -> { where("brou") }
  scope :visa, -> { where("visa") }
  scope :oca, -> { where("oca") }

  def nombre_clase()
  	return "Cuenta"
  end

  def tostr()
  	return "#{id} - #{nombre}" 
  end

  def self.coleccion()
  	return Cuenta.all.order(:id).map{|u| [u.tostr(),u.id]} 
  end

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
