class CreateAfinidad2020Alumnos < ActiveRecord::Migration[5.2]
  def change
    create_table :afinidad2020_alumnos do |t|
      t.integer :alumno

      t.timestamps
    end
  end
end
