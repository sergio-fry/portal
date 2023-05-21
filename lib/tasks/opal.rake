namespace :opal do
  desc 'Update Opal runtime'
  task update_runtime: :environment do
    require 'tempfile'

    version = `opal -v`.match(/\d+\.\d+\.\d+/)[0]
    target_dir = Rails.root.join('vendor/javascript/opal')

    Tempfile.create('runtime') do |runtime|
      Tempfile.create('prog') do |prog|
        `opal --require native --compile #{prog.path} > #{runtime.path}`
      end

      `mkdir -p #{target_dir}`
      `cp #{runtime.path} #{target_dir.join('runtime.js')}`
      `echo "#{version}" > #{target_dir.join('VERSION')}`
    end
  end
end
