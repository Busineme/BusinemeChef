# Variables
HOME = "/home/vagrant"
SHARED_DIR = "/vagrant"
REPOWEB_DIR = "#{SHARED_DIR}/repo/busine-me"
REPOAPI_DIR = "#{SHARED_DIR}/repo/busine-meAPI"

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

execute 'cp configuration/databases.py.template configuration/databases.py' do
  cwd "#{REPOWEB_DIR}"
end

execute 'cp configuration/security.py.template configuration/security.py' do
  cwd "#{REPOWEB_DIR}"
end

execute 'cp configuration/api.py.template configuration/api.py' do
  cwd "#{REPOWEB_DIR}"
end


# # Configure MariaDB
# include_recipe "mariadb::server"
# include_recipe "mariadb::client"

# package "libmysqlclient-dev"

# execute "create_database" do
#   command "mysqladmin create busine-me -u root"
#   not_if "mysql -u root -e 'use busine-me;'"
# end

# Configure MariaDB
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


git "#{REPOAPI_DIR}" do
  repository "https://github.com/Busineme/BusinemeAPI.git"
  action :sync
end

execute 'cp configuration/databases.py.template configuration/databases.py' do
  cwd "#{REPOAPI_DIR}"
end

execute 'cp configuration/security.py.template configuration/security.py' do
  cwd "#{REPOAPI_DIR}"
end

