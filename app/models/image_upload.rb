class ImageUpload

  def initialize(opts = {})
    @compute = opts[:compute]
  end

  private
  attr_reader :compute

end
