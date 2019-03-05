class AdminUsuario < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable


  has_many :usuario_sector, -> { order(indice: :asc) }, :dependent => :delete_all
  accepts_nested_attributes_for :usuario_sector, allow_destroy: true

end
