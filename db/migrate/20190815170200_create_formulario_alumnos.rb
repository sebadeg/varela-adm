class CreateFormularioAlumnos < ActiveRecord::Migration[5.2]
  def change
    create_table :formulario_alumnos do |t|
      t.integer :formulario

      t.timestamps
    end
  end
end
