package "postgresql"

cookbook_file "/etc/postgresql/9.3/main/pg_hba.conf" do
	user 'postgres'
	group 'postgres'
	mode 0600
	notifies :restart, 'service[postgresql]'
end


execute 'createuser:busineme' do
	command "createuser busineme"
	user 'postgres'
	not_if do
		`sudo -u postgres -i psql -c "select * from pg_user where usename = 'busineme';" | grep -c busineme`
	end
end

execute 'createdb:busineme' do
	command 'createdb busineme —owner=busineme'
	user 'postgres'
	not_if do
		`sudo -u postgres -i psql -c "select * from pg_database where datname = 'busineme';" | grep -c busineme`
	end
end 

service 'postgresql' do
	action [:enable, :start]
	supports :restart => true
end