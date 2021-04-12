require 'time'
require 'fileutils'

module Utils; module SnapshotHelpers
  def update_version(version_file, version_type)
    current_version, _ = parse_version_file(version_file)
    new_version = bump_version_number(current_version, version_type)
    update_version_file(version_file, new_version)
    new_version
  end

  def pull_latest
    system_or_die("git pull")
  end

  def push_changes
    system_or_die("git push origin master --tags")
  end

  def commit_db_update(submodule_dir, file, commit_message)
    cur_dir = Dir.pwd
    Dir.chdir(submodule_dir)
    system_or_die("git add #{File.basename(file)}")
    system_or_die("git commit -m '#{commit_message}'")
    system_or_die("git push origin master")
    Dir.chdir(cur_dir)
  end

  def commit_data_submodule_update(commit_message, *files)
    files.each { |f| system_or_die("git add #{f}") }
    system_or_die("git commit -m '#{commit_message}'")
  end

  def create_tag(version_number)
    system_or_die("git tag -a v#{version_number} -m 'tag for v#{version_number}'")
  end

  def in_git_stash
    pwd = Dir.pwd
    result = `git stash`
    yield
  ensure
    Dir.chdir(pwd)
    system_or_die('git stash pop') unless result =~ /No local changes/
  end

  def update_data_submodule
    system_or_die("git submodule update --init data")
  end

  def download_data_dump(destination)
    unless Dir.exist? 'data'
      Dir.mkdir('data')
    end
    system_or_die("wget -O #{destination} http://dgidb.org/data/data.sql")
  end

  private
  def system_or_die(syscall)
    puts syscall
    system(syscall) or raise "Failed trying to #{syscall} in #{Dir.pwd}"
  end

  def bump_version_number(old_version, revision_type)
    parts = {}
    parts[:major], parts[:minor], parts[:patch] = old_version.split('.')
    if revision_type == :major
      parts[:major].next!
      parts[:minor] = '0'
      parts[:patch] = '0'
    elsif revision_type == :minor
      parts[:minor].next!
      parts[:patch] = '0'
    elsif revision_type == :patch
      parts[:patch].next!
    else
      raise StandardError.new("Unsupported revision type #{revision_type}. Must be one of :major, :minor, :patch")
    end
    parts.values.join('.')
  end

  def parse_version_file(path)
    File.read(path)
      .strip
      .split("\t")
  end

  def current_sha
    `git log --pretty=format:'%h' --abbrev-commit -1`.strip
  end

  def update_version_file(version_file, new_version)
    File.open(version_file, 'w') { |f| f.puts [new_version, Time.now, current_sha].join("\t") }
  end

end; end
