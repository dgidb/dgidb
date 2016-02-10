require 'rye'

namespace :dgidb do
  desc 'deploy a new version of dgidb to the public server'
  task :deploy do
    Rake::Task['dgidb:build_package'].execute
    Rake::Task['dgidb:publish_package'].execute
  end

  desc 'build and install the debian package on the staging box'
  task :stage do
    Rake::Task['dgidb:build_package'].execute
    staging_box = Rye::Box.new('vmpool26', user: 'vmuser', safe: false)
    puts '====INSTALL THE PACKAGE===='
    puts 'sudo dpkg -i dgi-db_*.deb'
    puts '==========================='
    staging_box.interactive_ssh
  end

  desc 'publish built package to puppet'
  task :publish_package do
    workstation = Rye::Box.new('linus202', user: 'awagner', safe: false)
    workstation.cd('deploy')
    workstation.rm(:f, '*')
    workstation.scp('vmuser@vmpool26:dgi-db_*', '.')
    puts '=====SIGN YOUR PACKAGE====='
    puts 'cd deploy && debsign -k$MYGPGKEY *.changes && exit'
    puts '==========================='
    workstation.interactive_ssh
    workstation.chgrp('info', '*')
    workstation.chmod('664', '*')
    workstation.dput('precise-genome-development', '*.changes')
  end

  desc 'build the debian package on the staging box'
  task :build_package do
    staging_box = Rye::Box.new('vmpool26', user: 'vmuser', safe: false)
    staging_box.rm(:f, 'dgi-db_*')
    staging_box.cd('dgi-db')
    staging_box.git('pull')
    # staging_box.cd('data')
    # staging_box.git('pull')
    staging_box.cd
    staging_box.cp(:f, './deploy/database.yml', './dgi-db/config/database.yml')
    staging_box.execute('./deploy/bump_changelog')
    staging_box.cp(:f, './deploy/changelog', './dgi-db/debian/')
    staging_box.cd('dgi-db')
    staging_box.execute('dpkg-buildpackage', "--changes-option='-DDistribution=precise-genome-development'")
  end
end