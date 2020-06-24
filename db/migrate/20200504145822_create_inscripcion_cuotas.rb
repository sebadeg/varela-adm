class CreateInscripcionCuotas < ActiveRecord::Migration[5.2]
  def change
    create_table :inscripcion_cuotas do |t|
      t.belongs_to :inscripcion, foreign_key: true
      t.date :fecha
      t.string :descripcion_cuota
      t.string :descripcion_descuento
      t.integer :cuota
      t.integer :total_cuotas     
      t.decimal :importe
      t.decimal :descuento
      t.decimal :total_importe
      t.timestamps
    end
  end
end
