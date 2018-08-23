class Inscripcion < ApplicationRecord
  belongs_to :convenio
  belongs_to :proximo_grado

  validates :nombre, presence: true

  validates :cedula, presence: true
  validates :cedula, numericality: { only_integer: true, greater_than:0, less_than: 100000000 }

  validates :proximo_grado_id, presence: true
  validates :convenio_id, presence: true
  validates :matricula, presence: true
  validates :hermanos, presence: true
  validates :cuotas, presence: true
  validates :cuotas, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }

  validates :nombre1, presence: true
  validates :email1, presence: true
  validates :documento1, presence: true
  validates :documento1, numericality: { only_integer: true, greater_than:0, less_than: 100000000 }
  validates :domicilio1, presence: true
  validates :celular1, presence: true

  validates :documento1, numericality: { only_integer: true, allow_nil: true, greater_than:0, less_than: 100000000 }


  validate :cedula_digit
  validate :documento1_digit
  validate :documento2_digit


  def calc_cedula(ced)
    if ( ced == nil )      
      return true
    end
    suma = 0
    arr = [4,3,6,7,8,9,2]
    digit = ced%10 
    c = ced/10
    (0..6).each do |i|
       r = c%10
       c = c/10
       suma = (suma + r*arr[i]) % 10
    end
    if digit != ((10-(suma%10))%10)
      return false
    end
    return true
  end

  def cedula_digit
    if (!calc_cedula(cedula))
      errors.add(:cedula, "con dígito verificador mal")
    end
  end

  def documento1_digit
    if (!calc_cedula(documento1))
      errors.add(:documento1, "con dígito verificador mal")
    end
  end

  def documento2_digit
    if (!calc_cedula(documento2))
      errors.add(:documento2, "con dígito verificador mal")
    end
  end
end
