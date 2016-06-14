# coding: utf-8
require File.expand_path('../lib/foreman_image_upload/version', __FILE__)
require 'date'

Gem::Specification.new do |s|
  s.name        = 'foreman_image_upload'
  s.version     = ForemanImageUpload::VERSION
  s.date        = Date.today.to_s
  s.authors     = ['Guido Günther']
  s.email       = ['agx@sigxcpu.org']
  s.summary     = 'Upload virtual machine images to the Foreman.'
  # also update locale/gemspec.rb
  s.description = 'Upload virtual machine images to the Foreman.'

  s.files = Dir['{app,config,db,lib,locale}/**/*'] + ['LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'deface'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rdoc'
end
