require 'yaml'


$BUSINEME_ENV = ENV.fetch('BUSINEME_ENV','local')


ips_file = "config/#{$BUSINEME_ENV}/ips.yaml"
ssh_config_fie = "config/#{$BUSINEME_ENV}/ssh_config"
config_file = "config/#{$BUSINEME_ENV}/config.yaml"

ENV['CHAKE_TMPDIR'] = "tmp/chake.#{$BUSINEME_ENV}"
ENV['CHAKE_SSH_CONFIG'] = ssh_config_fie

ips ||= YAML.load_file(ips_file)
config ||= YAML.load_file(config_file)

$nodes.each do |node|
	node.data['config'] = config
	node.data['peers'] = ips
end

require "chake"

task :bootstrap_common => 'config/local/ssh_config'

file 'ssh_config.erb'
if ['local'].include?($SPB_ENV)
	file ssh_config_file => ['nodes.yaml', ips_file, 'ssh_config.erb', 'Rakefile'] do |t|
		require 'erb'
		template = ERB.new(File.read('ssh_config.erb'))
		File.open(t.name, 'w') do |f|
			f.write(template.result(binding))
		end
	puts 'ERB %s' % t.name
	end
end

