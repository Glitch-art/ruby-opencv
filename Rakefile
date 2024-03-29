# -*- mode: ruby; coding: utf-8 -*-
require 'rubygems'
require "rubygems/ext"
require "rubygems/installer"
require 'hoe'
require 'rake/extensiontask'
require 'fileutils'
require './lib/opencv/psyched_yaml'
require 'yard'
require 'yard/rake/yardoc_task'
require './yard_extension'

SO_FILE = 'opencv.so'

Hoe.plugin :gemspec

hoespec = Hoe.spec 'ruby-opencv' do |s|
  s.summary = 'OpenCV wrapper for Ruby'
  s.description = 'ruby-opencv is a wrapper of OpenCV for Ruby. It helps you to write computer vision programs (e.g. detecting faces from pictures) with Ruby.'
  s.licenses = ['BSD-3-Clause']
  s.developer('lsxi', 'masakazu.yonekura@gmail.com')
  s.developer('ser1zw', 'azariahsawtikes@gmail.com')
  s.developer('pcting', 'pcting@gmail.com')

  s.readme_file  = 'README.md'
  s.history_file = 'History.txt'

  s.spec_extras = { :extensions => ['ext/opencv/extconf.rb'] }

  s.test_globs = ['test/test_*.rb']
  s.urls = {'home' => 'https://github.com/ruby-opencv/ruby-opencv/'}

  s.extra_dev_deps << ['rake-compiler', '~> 0'] << ['hoe-gemspec', '~> 0']

  Rake::ExtensionTask.new('opencv', spec) do |ext|
    ext.lib_dir = 'lib'
  end
end

hoespec.spec.files.delete('.gemtest')

Rake::Task[:test].prerequisites << :compile

desc 'Create a pre-compiled gem'
task 'gem:precompile' => ['gem'] do
  tmp_dir = Dir.mktmpdir('tmp', '.')
  gemfile = Dir.glob("pkg/*.gem")[0]
  target_dir = File.join(tmp_dir, File.basename(gemfile, '.gem'))

  installer = Gem::Installer.new(gemfile)
  installer.unpack(target_dir)

  gemspec = installer.spec
  extension = gemspec.extensions[0]
  gemspec.extensions.clear

  config = ENV['CONFIG'] ?  YAML.load_file(ENV['CONFIG']) : {}
  rubies = config['rubies'] || [Gem.ruby]
  args = config['extopts'] || []
  gemspec.platform = config['platform'] || Gem::Platform::CURRENT

  multi = rubies.size > 1
  rubies.each { |ruby|
    lib_dir = 'lib'
    if multi
      major, minor, _ = `#{ruby} -e "print RUBY_VERSION"`.chomp.split('.')
      lib_dir = File.join(lib_dir, [major, minor].join('.'))
    end

    make_cmd = (`#{ruby} -e "print RUBY_PLATFORM"` =~ /mswin/) ? 'nmake' : 'make'
    Dir.chdir(target_dir) {
      cmd = [ruby, extension, *args].join(' ')
      results = []
      Gem::Ext::ExtConfBuilder.run(cmd, results)
      Gem::Ext::ExtConfBuilder.make('', results)

      FileUtils.mkdir_p lib_dir
      FileUtils.mv SO_FILE, lib_dir
      sh "#{make_cmd} clean"
    }

    gemspec.files << File.join(lib_dir, SO_FILE)
  }

  Dir.chdir(target_dir) {
    gemfile = Gem::Package.build(gemspec)
    FileUtils.mv gemfile, File.dirname(__FILE__)
  }

  FileUtils.rm_rf tmp_dir
end

# yard
YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb', 'ext/**/*.cpp']
end

# vim: syntax=ruby

