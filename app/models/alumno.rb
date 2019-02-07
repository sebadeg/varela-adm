class Alumno < ApplicationRecord
  has_many :lista_alumno
  accepts_nested_attributes_for :lista_alumno, allow_destroy: true


  def self.consulta(user)

    s = ""
    if user.primaria
      s = "1"
    end
    if user.sec_mdeo
      if s != ""
        s = s + ","
      end
      s = s + "2"
    end
    if user.sec_cc
      if s != ""
        s = s + ","
      end
      s = s + "3"
    end
    return "IN (SELECT alumno_id FROM lista_alumnos WHERE lista_id IN (SELECT id FROM listas WHERE sector_id IN (" + s + ") AND anio IN (SELECT anio FROM configs WHERE NOT anio IS NULL)))"
  end


  def self.grado(id)
    if id!=nil
      grado = Grado.where("id IN (SELECT grado_id FROM grado_alumnos WHERE alumno_id=#{id} AND NOT grado_id IS NULL)").rescue nil
      if grado != nil
        return grado.nombre
      end
    end
    return ""
  end
end
