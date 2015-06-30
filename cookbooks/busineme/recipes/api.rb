# Variables
$BUSINEME_ENV = ENV.fetch('BUSINEME_ENV', 'local')
package "vim"

package "python2.7" 
package "python-pip" 
package "python-dev"
package "postgresql-contrib"
package "libpq-dev" 
package "postgresql"
package "git"

package "libxml2"
package "libxslt1.1"
package "libxml2-dev"
package "libxslt1-dev"
package "python-libxml2"
package "python-libxslt1"
package "python-lxml"
package "python-setuptools"
package "python-Levenshtein"
package "python-psycopg2"

include_recipe "git"

if ['local'].include?($BUSINEME_ENV)
  REPODIR = node['config']['DIRECTORIES']['API_REPO_LOCAL']
  DEBUG = 'True'
  directory "#{REPODIR}" do
    recursive true
  end
else
  DEBUG = 'False'
  REPODIR = node['config']['DIRECTORIES']['API_REPO_PROD']
end

git "#{REPODIR}" do
  repository node['config']['APPLICATION']['API_REPOSITORY']
  action :sync
end


execute 'pip install -r requirements.txt' do
  cwd "#{REPODIR}"
end

template "#{REPODIR}/configuration/databases.py" do
  source "databases.py.erb"
end

template "#{REPODIR}/configuration/security.py" do
  source "security.py.erb"
  variables({:DEBUG => DEBUG})
end

execute 'python manage.py makemigrations' do
  cwd "#{REPODIR}"
end

execute 'python manage.py migrate' do
  cwd "#{REPODIR}"
end

