class AddWebhookSecretToProject < ActiveRecord::Migration
  def change
    add_column :projects, :webhook_secret, :string
    add_index :projects, :webhook_secret
  end
end
