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

# # Configure postgresql
# include_recipe "postgresql::server"

# cookbook_file "/etc/postgresql/#{node[:postgresql][:version]}/main/pg_hba.conf" do
#     source "pg_hba.conf"
#     owner "postgres"
# end

# execute "restart postgres" do
#     command "sudo /etc/init.d/postgresql restart"
# end

# execute "create database" do
#     command "createdb -U postgres -T template0 -O postgres #{node[:dbname]} -E UTF8 --locale=en_US.UTF-8"
#     not_if "psql -U postgres --list | grep #{node[:dbname]}"
# end


# execute 'python manage.py makemigrations' do
#   cwd "#{REPOWEB_DIR}"
# end

# execute 'python manage.py migrate' do
#   cwd "#{REPOWEB_DIR}"
# end



# git "#{REPOAPI_DIR}" do
#   repository "https://github.com/Busineme/BusinemeAPI.git"
#   action :sync
# end

# execute 'pip install -r requirements.txt' do
#   cwd "#{REPOAPI_DIR}"
# end

# execute 'cp configuration/databases.py.template configuration/databases.py' do
#   cwd "#{REPOAPI_DIR}"
# end

# execute 'cp configuration/security.py.template configuration/security.py' do
#   cwd "#{REPOAPI_DIR}"
# end

# execute 'python manage.py makemigrations' do
#   cwd "#{REPOAPI_DIR}"
# end

# execute 'python manage.py migrate' do
#   cwd "#{REPOAPI_DIR}"
# end

# execute 'python manage.py import_data' do
#   cwd "#{REPOAPI_DIR}"
# end