class AddBestAnswer < ActiveRecord::Migration[6.1]
  def change
    add_column :answers, :best?, :boolean, default: false, null: false
  end
end
