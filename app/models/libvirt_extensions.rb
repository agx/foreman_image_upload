module LibvirtExtensions
  extend ActiveSupport::Concern

  def upload_image source, pool_name, volume_name
    begin
      vol = new_volume(:name      => volume_name,
                       :pool_name => pool_name,
                       :capacity  => "#{File.size(source)}b")
      vol.save
      vol.upload_image source
    rescue Libvirt::Error => e
      raise Foreman::Exception.new("Cannot upload image '#{volume_name}' to '#{pool_name}': #{e}")
    end
  end
end
