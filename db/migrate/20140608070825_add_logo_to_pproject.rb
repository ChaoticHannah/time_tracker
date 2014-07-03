class AddLogoToPproject < ActiveRecord::Migration
  def self.up
    add_attachment :projects, :logo
  end

  def self.down
    remove_attachment :projects, :logo
  end
end
