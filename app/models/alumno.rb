class Alumno < ApplicationRecord
  has_many :cuenta_alumno, :dependent => :delete_all
  accepts_nested_attributes_for :cuenta_alumno, allow_destroy: true

  has_many :padre_alumno, :dependent => :delete_all
  accepts_nested_attributes_for :padre_alumno, allow_destroy: true

  has_many :linea_factura, :dependent => :delete_all
  accepts_nested_attributes_for :linea_factura, allow_destroy: true

  has_many :lista_alumno
  accepts_nested_attributes_for :lista_alumno, allow_destroy: true

  has_many :actividad_alumno

  def nombre_clase()
  	return "Alumno"
  end

  def tostr()
  	return "#{id} - #{nombre} #{apellido}" 
  end

  def self.coleccion()
  	return Alumno.all.order(:nombre,:apellido).map{|u| [u.tostr(),u.id]} 
  end

  def self.sector_num(user)
    if user.primaria
      return 1
    end
    if user.sec_mdeo
      return 2
    end
    if user.sec_cc
      return 3
    end
    return 0
  end

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

  def self.sector(user)
    s = "0"
    if user.primaria
      s = s + ",1"
    end
    if user.sec_mdeo
      s = s + ",2"
    end
    if user.sec_cc
      s = s + ",3"
    end
    return s
  end

  def self.grado(id)
    if id!=nil
      grado = Grado.where("id IN (SELECT grado_id FROM grado_alumnos WHERE alumno_id=#{id} AND NOT grado_id IS NULL)").first rescue nil
      if grado != nil
        return grado.nombre
      end
    end
    return ""
  end
end
