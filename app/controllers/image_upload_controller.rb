require 'tmpdir'

class ImageUploadController < ApplicationController
  before_filter :find_compute

  def index
  end

  def new
    # Needed for form
    @image_info = ImageInfo.new
  end

  def create
    uploaded = params[:image_info][:image]
    source = safe_copy uploaded

    # FIXME: allow to set volume name
    @image_info = ImageInfo.new(:source => source,
                                :pool_name => params[:image_info][:pool_name],
                                :volume_name => File.basename(uploaded.original_filename))
    begin
      @compute.upload_image(@image_info.source,
                            @image_info.pool_name,
                            @image_info.volume_name)

      process_success({:success_redirect => compute_resource_image_upload_index_path(@compute),
                       :success_msg => "Successfully uploaded '#{@image_info.volume_name}' to '#{@image_info.pool_name}'"}
                     )
    rescue Foreman::Exception => e
      process_error({:error_redirect => compute_resource_image_upload_index_path(@compute),
                     :error_msg => "#{e}"})
    end

    rm_copy
  end

  def find_compute
    return not_found unless params[:compute_resource_id].present?
    @compute = ::ComputeResource.find(params[:compute_resource_id])
    return not_found unless @compute.capabilities.include?(:image)
  end

  private

  def safe_copy(uploaded)
    # FIXME: need to fix fog to accep IO instead of filename to save
    # fthe extra copy
    image_dir = Rails.root.join 'uploaded_images'
    Dir.mkdir image_dir unless File.directory? image_dir

    source = image_dir.join uploaded.original_filename
    File.open(source, 'wb') do |f|
      f.write(uploaded.read)
    end
    source
  end

  def rm_copy
    File.unlink @image_info.source if File.exists? @image_info.source
    @image_info.source = nil
  end

end
