class Usuario < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, authentication_keys: [:cedula]

  has_many :titular_cuenta
  accepts_nested_attributes_for :titular_cuenta, allow_destroy: true

  has_many :padre_alumno
  accepts_nested_attributes_for :padre_alumno, allow_destroy: true

  def nombre_clase()
    return "Usuario"
  end

  def tostr()
    return "#{nombre} #{apellido}" 
  end

  def self.coleccion()
    return Usuario.all.order(:nombre,:apellido).map{|u| [u.tostr(),u.id]} 
  end






  
  validates_uniqueness_of :cedula
  validates :cedula, presence: true
  validates :cedula, numericality: { only_integer: true, greater_than:0, less_than: 100000000 }
  validate :cedula_digit




  def password_required?
    super if validado?
  end

  def email_required?
    true
  end 




  def cedula_digit
    if ( cedula == nil )      
      return
    end
    suma = 0
    arr = [4,3,6,7,8,9,2]
    digit = cedula%10 
    c = cedula/10
    (0..6).each do |i|
       r = c%10
       c = c/10
       suma = (suma + r*arr[i]) % 10
    end
    if digit != ((10-(suma%10))%10)
      errors.add(:cedula, "con dígito verificador mal")
    end
  end



end

