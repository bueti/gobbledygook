class AddDraftToEntry < ActiveRecord::Migration[6.1]
  def change
    add_column :entries, :draft, :boolean, default: false
  end
end
