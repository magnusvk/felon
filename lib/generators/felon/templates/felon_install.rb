class FelonInstall < ActiveRecord::Migration
  def self.up
    create_table :experiments, force: true do |table|
      table.string :name, null: false
    end
    create_table :variants, force: true do |table|
      table.integer :experiment_id, null: false
      table.string :name, null: false
      table.integer :views, null: false, default: 0
      table.integer :interactions, null: false, default: 0
      table.integer :conversions, null: false, default: 0
    end
  end

  def self.down
    drop_table :experiments
    drop_table :variants
  end
end
