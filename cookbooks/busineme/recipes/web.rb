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
execute "pip install gunicorn"
package "nginx"
package "supervisor"
package "nginx"


include_recipe "git"

if ['local'].include?($BUSINEME_ENV)
  REPODIR = node['config']['DIRECTORIES']['WEB_REPO_LOCAL']
  DEBUG = 'True'
  directory "#{REPODIR}" do
    recursive true
  end
else
  DEBUG = 'False'
  REPODIR = node['config']['DIRECTORIES']['WEB_REPO_PROD']
end

git "#{REPODIR}" do
  repository node['config']['APPLICATION']['WEB_REPOSITORY']
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

template "#{REPODIR}/configuration/api.py" do
  source "api.py.erb"
end


execute 'python manage.py makemigrations' do
  cwd "#{REPODIR}"
end

execute 'python manage.py migrate' do
  cwd "#{REPODIR}"
end

template "/etc/supervisor/conf.d/busineme.conf" do
  source "busineme.conf.erb"
  variables({:REPODIR => REPODIR})
  mode 0600
end

template "#{REPODIR}/gunicorn_script" do
  source "gunicorn_script.erb"
  variables({:REPODIR => REPODIR})
  # mode 0775
end

service 'supervisor' do
  action :restart
end

execute 'supervisorctl start busineme' do
  cwd "#{REPODIR}"
end