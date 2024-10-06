# My Project
ansibleでwordpress構築
ansibleの動きを覚えるため構築

# enviloment
centOS7
vagrant

# 初期設定インストール
```
yum update
yum -y install epel-release
yum -y install vim
yum -y install wget
```

# vagrantで新規デプロイするために以下を記載

```
vim vagrantfile
Vagrant.configure("2") do |config|

  # ansibleの設定
  config.vm.define "vm1" do |vm1|
    vm1.vm.box = "centos/7"
    vm1.vm.hostname = "ansible"
    vm1.vm.network "private_network", ip: "192.168.50.4"
  end

end
```

# vagrant statusで以下ステータスになっているか確認
vm1                       running (virtualbox)

# vm1に接続
vagrant ssh vm1
sudo hostnamectl set-hostname vm1

#ansbleをインストール
cd ~
yum install epel-release
mkdir ansible
cd ansible
sudo yum install ansible

# 2台目構築
```
vim Vagrantfile
Vagrant.configure("2") do |config|

  # ansibleの設定
  config.vm.define "vm1" do |vm1|
    vm1.vm.box = "centos/7"
    vm1.vm.hostname = "ansible"
    vm1.vm.network "private_network", ip: "192.168.50.4"
    vm1.ssh.username = "menta"
    vm1.ssh.private_key_path = "./.ssh/menta-ssh-key"
  end
  # dev.menta.meの設定
  config.vm.define "vm2" do |vm2|
    vm2.vm.box = "centos/7"
    vm2.vm.hostname = "dev.menta.me"
    vm2.vm.network "private_network", ip: "192.168.50.5"
    # vm2.ssh.username = "menta"
    # vm2.ssh.private_key_path = "./.ssh/menta-ssh-key"
  end
end

```
vagrant up vm2
vagrant ssh vm2

# 初期設定インストールin vm2
yum update -y

# 共有フォルダ同期
```
vagrant plugin install vagrant-vbguest
Vagrantfileに以下を追記
config.vm.synced_folder "./vm1", "/var/www/ansible/", owner: 'menta', group: 'wheel'
config.vm.synced_folder "./vm2", "/var/www/dev.menta.me/", owner: 'menta', group: 'wheel'
```
# イベントリで使用するSSH秘密鍵をコピー
cp .ssh/menta-ssh-key vm1/

# イベントリ動作テスト

ansibleの設定ファイルは
/etc/ansibleディレクトリに置く


コピー先　/etc/ansible/
コピー元　/var/www/ansible/menta-ssh-key
コピー元　/var/www/ansible/hosts

```
sudo su -
vi hosts

vi ansible.cfg
[defaults]
hostfile=./hosts
remote_user=menta
private_key_file=./menta-ssh-key

[privilege_escalation]
become = True
```

# ディレクトリの構造
```
├── roles
│   ├── common
│   │   ├── tasks
│   │   │   └── main.yml
│   │   │   └── base-packages.yml
│   │   │   └── hostname.yml
├── group_vars
│   ├── all
```

# 構文チェック
ansible-playbook main.yml --syntax-check

# playbook実行
ansible-playbook main.yml