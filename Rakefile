# frozen_string_literal: true

require 'rake/testtask'
require_relative 'require_app'

task :default do
  puts `rake -T`
end

# NOTE: run `rake run:test` in another process
desc 'Run acceptance tests only'
Rake::TestTask.new(:spec_accept) do |t|
  t.pattern = 'spec/tests/acceptance/*_spec.rb'
  t.warning = false
end

desc 'Generates a 64 by secret for Rack::Session'
task :new_session_secret do
  require 'base64'
  require 'SecureRandom'
  secret = SecureRandom.random_bytes(64).then { Base64.urlsafe_encode64(_1) }
  puts "SESSION_SECRET: #{secret}"
end

desc 'Run the application (default: development mode)'
task run: ['run:dev']

namespace :run do
  desc 'Run the application in development mode'
  task :dev do
    sh "rerun -c --ignore 'coverage/*' --ignore 'repostore/*' -- bundle exec puma -p 9000"
  end

  desc 'Run the application in test mode'
  task :test do
    sh "rerun -c --ignore 'coverage/*' --ignore 'repostore/*' -- bundle exec puma -p 9000"
  end
end

desc 'Run application console'
task :console do
  sh 'pry -r ./load_all'
end

namespace :quality do
  only_app = 'config/ app/'

  desc 'run all static-analysis quality checks'
  task all: %i[rubocop reek flog]

  desc 'code style linter'
  task :rubocop do
    sh 'rubocop'
  end

  desc 'code smell detector'
  task :reek do
    sh 'reek'
  end

  desc 'complexiy analysis'
  task :flog do
    sh "flog -m #{only_app}"
  end
end
