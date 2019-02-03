class Alumno < ApplicationRecord
  has_many :lista_alumno
  accepts_nested_attributes_for :lista_alumno, allow_destroy: true


  def self.consulta()

    s = ""
    if current_admin_usuario.primaria
      s = "1"
    end
    if current_admin_usuario.sec_mdeo
      if s != ""
        s = s + ","
      end
      s = s + "2"
    end
    if current_admin_usuario.sec_cc
      if s != ""
        s = s + ","
      end
      s = s + "3"
    end
    return "IN (SELECT alumno_id FROM lista_alumnos WHERE lista_id IN (SELECT id FROM listas WHERE sector_id IN (" + s + ") AND anio IN (SELECT anio FROM configs WHERE NOT anio IS NULL)))"
  end
end
