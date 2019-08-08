class CreateFormularioOpciones < ActiveRecord::Migration[5.2]
  def change
    create_table :formulario_opciones do |t|
      t.integer :formulario
      t.integer :inscripcion_opcion

      t.timestamps
    end
  end
end
