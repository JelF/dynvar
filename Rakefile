# frozen_string_literal: true
require 'bundler/gem_tasks'
require 'yard'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'

ROOT = Pathname.new(__FILE__).join('..')

YARD::Rake::YardocTask.new(:doc) do |t|
  t.files = Dir[ROOT.join('lib/**/*.rb')]
  t.options = %w(--private)
end

RuboCop::RakeTask.new
RSpec::Core::RakeTask.new(:spec)

task default: %i(rubocop spec doc:coverage)

namespace :doc do
  desc 'checks doc coverage'
  task coverage: :doc do
    # ideally you've already generated the database to .load it
    # if not, have this task depend on the docs task.
    YARD::Registry.load
    objs = YARD::Registry.select do |o|
      puts "pending #{o}" if o.docstring =~ /TODO|FIXME|@pending/
      o.docstring.blank?
    end

    next if objs.empty?
    puts 'No documentation found for:'
    objs.each { |x| puts "\t#{x}" }

    raise '100% document coverage required'
  end
end
