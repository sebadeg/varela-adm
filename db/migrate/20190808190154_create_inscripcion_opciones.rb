class CreateInscripcionOpciones < ActiveRecord::Migration[5.2]
  def change
    create_table :inscripcion_opciones do |t|
      t.integer :tipo
      t.integer :anio
      t.date :fecha
      t.decimal :valor
      t.string :formato

      t.timestamps
    end
  end
end
