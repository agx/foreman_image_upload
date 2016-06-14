# Tasks
namespace :foreman_image_upload do
  namespace :example do
    desc 'Example Task'
    task task: :environment do
      # Task goes here
    end
  end
end

# Tests
namespace :test do
  desc 'Test ForemanImageUpload'
  Rake::TestTask.new(:foreman_image_upload) do |t|
    test_dir = File.join(File.dirname(__FILE__), '../..', 'test')
    t.libs << ['test', test_dir]
    t.pattern = "#{test_dir}/**/*_test.rb"
    t.verbose = true
    t.warning = false
  end
end

namespace :foreman_image_upload do
  task :rubocop do
    begin
      require 'rubocop/rake_task'
      RuboCop::RakeTask.new(:rubocop_foreman_image_upload) do |task|
        task.patterns = ["#{ForemanImageUpload::Engine.root}/app/**/*.rb",
                         "#{ForemanImageUpload::Engine.root}/lib/**/*.rb",
                         "#{ForemanImageUpload::Engine.root}/test/**/*.rb"]
      end
    rescue
      puts 'Rubocop not loaded.'
    end

    Rake::Task['rubocop_foreman_image_upload'].invoke
  end
end

Rake::Task[:test].enhance ['test:foreman_image_upload']

load 'tasks/jenkins.rake'
if Rake::Task.task_defined?(:'jenkins:unit')
  Rake::Task['jenkins:unit'].enhance ['test:foreman_image_upload', 'foreman_image_upload:rubocop']
end
