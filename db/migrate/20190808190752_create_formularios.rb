class CreateFormularios < ActiveRecord::Migration[5.2]
  def change
    create_table :formularios do |t|
      t.integer :convenio

      t.timestamps
    end
  end
end
