Deface::Override.new(:virtual_path => 'compute_resources/index',
                     :name => 'upload_image',
                     :insert_top => 'td:last',
                     :text => "<%= link_to 'Image upload',compute_resource_image_upload_index_path(compute), :class => 'btn btn-default btn-sm', :disabled => !compute.capabilities.include?(:image) %>")
