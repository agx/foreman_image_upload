class ImageInfo
  include ActiveModel::Model
  attr_accessor :source
  # Libvirt specific
  attr_accessor :pool_name, :volume_name
end
