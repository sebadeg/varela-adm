class AddFechoToInscripcion2020 < ActiveRecord::Migration[5.2]
  def change
    add_column :inscripcion2020s, :fecha_comienzo, :date
    add_column :inscripcion2020s, :fecha_fin, :date
  end
end
