##
# A GitSet represents gems that are sourced from git repositories.
#
# This is used for gem dependency file support.
#
# Example:
#
#   set = Gem::DependencyResolver::GitSet.new
#   set.add_git_gem 'rake', 'git://example/rake.git', tag: 'rake-10.1.0'

class Gem::DependencyResolver::GitSet < Gem::DependencyResolver::Set

  ##
  # A Hash containing git gem names for keys and a Hash of repository and
  # git commit reference as values.

  attr_reader :repositories # :nodoc:

  def initialize # :nodoc:
    @git          = ENV['git'] || 'git'
    @repositories = {}
  end

  def add_git_gem name, repository, reference = 'HEAD' # :nodoc:
    @repositories[name] = [repository, reference]
  end

  def load_spec name, version, platform, source # :nodoc:
    source = Gem::Source::Git.new name, *@repositories[name]

    source.update

    gemspec = File.join source.install_dir, "#{name}.gemspec"

    Gem::Specification.load gemspec
  end

end
