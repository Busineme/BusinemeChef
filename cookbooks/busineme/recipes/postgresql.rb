package "postgresql"

if ['local'].include?($BUSINEME_ENV)
  DEBUG = 'True'
  directory "#{REPODIR}" do
    recursive true
  end
else
  DEBUG = 'False'
end

template "/etc/postgresql/#{node['config']['DATABASE']['VERSION']}/main/pg_hba.conf" do
	source 'pg_hba.conf.erb'
	user 'postgres'
	group 'postgres'
	mode 0600
	notifies :restart, 'service[postgresql]', :immediately
end

DB_USER = node['config']['DATABASE']['USER']
DB_PASSWORD = node['config']['DATABASE']['PASSWORD']
DB_NAME = node['config']['DATABASE']['NAME']
execute "createuser:#{DB_USER}" do
	command "psql -c \"CREATE USER #{DB_USER} WITH PASSWORD '#{DB_PASSWORD}';\""
	user 'postgres'
	not_if "sudo -u postgres psql -c \"select * from pg_user where usename = '#{DB_USER}';\" | grep -c #{DB_USER}"
end

execute "createdb:#{DB_NAME}" do
	command "createdb #{DB_NAME} --owner=#{DB_USER}"
	user 'postgres'
	not_if "sudo -u postgres psql -c \"select * from pg_database where datname = '#{DB_NAME}';\" | grep -c #{DB_NAME}"
end

service 'postgresql' do
	action [:enable, :start]
	supports :restart => true
end