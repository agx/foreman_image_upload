require 'deface'

module ForemanImageUpload
  class Engine < ::Rails::Engine
    engine_name 'foreman_image_upload'

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/overrides"]

    # Add any db migrations
    initializer 'foreman_image_upload.load_app_instance_data' do |app|
      ForemanImageUpload::Engine.paths['db/migrate'].existent.each do |path|
        app.config.paths['db/migrate'] << path
      end
    end

    initializer 'foreman_image_upload.register_plugin', :before => :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_image_upload do
        requires_foreman '>= 1.4'

        # Add a new role called 'ForemanImageUpload' if it doesn't exist
        #role 'ForemanImageUpload', [:view_foreman_image_upload]

        # add dashboard widget
        widget 'foreman_image_upload_widget', name: N_('Foreman plugin template widget'), sizex: 4, sizey: 1
      end
    end

    # Precompile any JS or CSS files under app/assets/
    # If requiring files from each other, list them explicitly here to avoid precompiling the same
    # content twice.
    assets_to_precompile =
      Dir.chdir(root) do
        Dir['app/assets/javascripts/**/*', 'app/assets/stylesheets/**/*'].map do |f|
          f.split(File::SEPARATOR, 4).last
        end
      end
    initializer 'foreman_image_upload.assets.precompile' do |app|
      app.config.assets.precompile += assets_to_precompile
    end
    initializer 'foreman_image_upload.configure_assets', group: :assets do
      SETTINGS[:foreman_image_upload] = { assets: { precompile: assets_to_precompile } }
    end

    # Include concerns in this config.to_prepare block
    config.to_prepare do
      begin
        ::ImageInfo.send :include, ::ActiveModel::AttributeMethods
        ::ImageInfo.send :include, ::ActiveModel::Conversion
        ::ImageInfo.send :extend, ::ActiveModel::Naming
      #::ImageInfo.send :include, ForemanImageUplod::ImageInfo

        ::Foreman::Model::Libvirt.send :include, LibvirtExtensions
      rescue => e
        Rails.logger.warn "ForemanImageUpload: skipping engine hook (#{e})"
      end
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanImageUpload::Engine.load_seed
      end
    end

    initializer 'foreman_image_upload.register_gettext', after: :load_config_initializers do |_app|
      locale_dir = File.join(File.expand_path('../../..', __FILE__), 'locale')
      locale_domain = 'foreman_image_upload'
      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end
  end
end
