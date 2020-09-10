class Afinidad2020 < ApplicationRecord

  has_many :afinidad2020_alumno, :dependent => :delete_all
  accepts_nested_attributes_for :afinidad2020_alumno, allow_destroy: true

  def toString()
    return "#{nombre} #{'%.2f' % descuento}%";
  end
  
end
