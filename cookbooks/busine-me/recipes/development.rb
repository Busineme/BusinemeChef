# Variables
HOME = "/home/vagrant"
SHARED_DIR = "/vagrant"
REPO_DIR = "#{SHARED_DIR}/repo/busine-me"

package "vim"

package "python2.7" 
package "python-pip" 
package "python-dev"
package "postgresql-contrib"
package "libpq-dev" 
package "postgresql" 

include_recipe 'git'


git "#{REPO_DIR}" do
  repository "https://github.com/aldarionsevero/BusinemeWeb"
  action :sync
end

execute 'pip install -r requirements.txt' do
  cwd '#{REPO_DIR}'
end
