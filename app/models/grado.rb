class Grado < ApplicationRecord
  has_many :subgrado

  def toString()
  	return "#{nombre} - $U #{precio}"
  end

end
