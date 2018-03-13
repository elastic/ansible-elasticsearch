Vagrant.configure("2") do |config|
  config.vm.provision "file", source: "license.json", destination: "/tmp/license.json"
  config.vm.provision "shell", inline: "curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py"
  config.vm.provision "shell", inline: "python get-pip.py"
  config.vm.provision "shell", inline: "pip install jmespath"
end
