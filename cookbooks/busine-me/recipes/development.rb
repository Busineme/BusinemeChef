# Variables
HOME = "/home/vagrant"
SHARED_DIR = "/vagrant"
REPOWEB_DIR = "#{SHARED_DIR}/repo/busine-me"
REPOAPI_DIR = "#{SHARED_DIR}/repo/busine-meAPI"
FILES_DIR = "#{SHARED_DIR}/files"

package "vim"

package "python2.7" 
package "python-pip" 
package "python-dev"
package "postgresql-contrib"
package "libpq-dev" 
package "postgresql"

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

include_recipe 'git'

git "#{REPOWEB_DIR}" do
  repository "https://github.com/aldarionsevero/BusinemeWeb"
  action :sync
end

execute 'pip install -r requirements.txt' do
  cwd "#{REPOWEB_DIR}"
end

# execute 'cp configuration/databases.py.template configuration/databases.py' do
#   cwd "#{REPOWEB_DIR}"
# end

# execute 'cp configuration/security.py.template configuration/security.py' do
#   cwd "#{REPOWEB_DIR}"
# end

execute 'cp databases.py ../repo/busine-me/configuration/databases.py' do
  cwd "#{FILES_DIR}"
end

execute 'cp security.py ../repo/busine-me/configuration/security.py' do
  cwd "#{FILES_DIR}"
end


execute 'cp configuration/api.py.template configuration/api.py' do
  cwd "#{REPOWEB_DIR}"
end

# Configure postgresql
include_recipe "postgresql::server"

cookbook_file "/etc/postgresql/#{node[:postgresql][:version]}/main/pg_hba.conf" do
    source "pg_hba.conf"
    owner "postgres"
end

execute "restart postgres" do
    command "sudo /etc/init.d/postgresql restart"
end

execute "create database" do
    command "createdb -U postgres -T template0 -O postgres #{node[:dbname]} -E UTF8 --locale=en_US.UTF-8"
    not_if "psql -U postgres --list | grep #{node[:dbname]}"
end


execute 'python manage.py makemigrations' do
  cwd "#{REPOWEB_DIR}"
end

execute 'python manage.py migrate' do
  cwd "#{REPOWEB_DIR}"
end



git "#{REPOAPI_DIR}" do
  repository "https://github.com/Busineme/BusinemeAPI.git"
  action :sync
end

execute 'pip install -r requirements.txt' do
  cwd "#{REPOAPI_DIR}"
end

execute 'cp configuration/databases.py.template configuration/databases.py' do
  cwd "#{REPOAPI_DIR}"
end

execute 'cp configuration/security.py.template configuration/security.py' do
  cwd "#{REPOAPI_DIR}"
end

execute 'python manage.py makemigrations' do
  cwd "#{REPOAPI_DIR}"
end

execute 'python manage.py migrate' do
  cwd "#{REPOAPI_DIR}"
end