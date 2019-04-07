Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/xenial64'
  config.vm.synced_folder '.', '/vagrant'
  config.vm.network :forwarded_port, guest: 4000, host: 4000
  config.vm.network "private_network", ip: "192.168.90.103"

  config.vm.provider 'virtualbox' do |vb|
    vb.memory = 2300
  end

  config.vm.provision 'ansible_local' do |ansible|
    ansible.playbook = 'playbook.yml'
    ansible.verbose = true
  end
end
