class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :title
      t.string :code
      t.integer :stock, default: 0
      #digitos con un tamaño maximo de 10 y 2 despues de la coma
      t.decimal :price, precision: 10, scale: 2, default: 0

      #Ex:- :default =>''

      t.timestamps
    end
  end
end
