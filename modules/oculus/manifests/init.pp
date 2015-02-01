class oculus {

   include redis

    package{['gcc-c++', 'patch', 'readline', 'readline-devel', 'zlib', 'zlib-devel', 'libyaml-devel', 'libffi-devel', 'openssl-devel', 'make', 'bzip2', 'autoconf', 'automake', 'libtool', 'bison', 'java-1.8.0-openjdk', 'java-1.8.0-openjdk-devel', 'ruby-devel', 'libxml2-devel', 'libxslt-devel']:
      ensure   => present,
      require   => Package['epel-release'],
   }

   file {'/etc/sysconfig/iptables':
      ensure   => present,
      content   => file('oculus/iptables'),
      mode      => '0600',
      owner      => 'root',
      group      => 'root',
      require   => Package['iptables'],
      notify   => Service['iptables'],
   }

   file {'/var/log/oculus':
      ensure   => directory,
      owner   => 'root',
      group   => 'root',
   }

   file {'/var/run/oculus':
      ensure   => directory,
      owner   => 'root',
      group   => 'root',
   }

   file { '/etc/init.d/puppet':
      ensure   => present,
      content   => file('oculus/init_puppet'),
      mode   => '0755',
      owner   => 'root',
      group   => 'root',
      notify    => Service['puppet'],
      require   => Package['puppet'],
   }

   file { '/opt/oculus/config/config.yml':
      ensure    => present,
      content   => file('oculus/oculus_config.yml'),
      mode      => '0644',
      owner     => 'root',
      group     => 'root',
      require   => Exec['/tmp/.install_oculus.sh'],
   }

   file { '/opt/oculus/Rakefile':
      ensure    => present,
      content   => file('oculus/oculus_Rakefile'),
      mode      => '0644',
      owner     => 'root',
      group     => 'root',
      require   => Exec['/tmp/.install_oculus.sh'],
    }

   file { '/opt/elasticsearch-0.90.3/config/elasticsearch.yml':
      ensure    => present,
      content   => file('oculus/elasticsearch.yml'),
      mode      => '0644',
      owner     => 'root',
      group     => 'root',
      require   => Exec['/tmp/.install_oculus.sh'],
   }

   file { '/etc/init.d/elasticsearch':
        ensure  => present,
        content => file('oculus/init_elasticsearch'),
        mode    => '0755',
        owner   => 'root',
        group   => 'root',
        require => Exec['/tmp/.install_oculus.sh'],
   }

   file { '/etc/init.d/thin':
        ensure  => present,
        content => file('oculus/init_thin'),
        mode    => '0755',
        owner   => 'root',
        group   => 'root',
        require => Exec['/tmp/.install_oculus.sh'],
   }

   file { '/etc/cron.d/oculus':
      ensure    => present,
      content   => file('oculus/cron_oculus'),
      mode      => '0644',
      owner     => 'root',
      group     => 'root',
      require   => File['/opt/oculus/scripts/import.sh'],
   }

   file { '/opt/oculus/scripts/import.sh':
      ensure    => present,
      content   => file('oculus/oculus_import.sh'),
      mode      => '0755',
      owner     => 'root',
      group     => 'root',
      require   => Exec['/tmp/.install_oculus.sh'],
   }

   file { '/tmp/.install_oculus.sh':
      ensure    => present,
      content   => file('oculus/install_oculus.sh'),
      mode      => '0755',
      owner     => 'root',
      group     => 'root',
   }

   exec {'/tmp/.install_oculus.sh':
      cwd   =>  '/opt/',
      creates   => '/opt/oculus/.install.done',
      timeout     => 1800,
      require   => [
         File['/tmp/.install_oculus.sh'],
         Package['java-1.8.0-openjdk'], 
         Package['java-1.8.0-openjdk-devel'],
         File['/var/log/oculus'],
         File['/var/run/oculus'],
      ],
   }

   service {'iptables':
      ensure   => running,
      enable   => true,
      require   => [
         File['/etc/sysconfig/iptables'],
         Package['iptables'],
      ],   
   }
   
   service { 'elasticsearch':
      ensure   => running,
      enable   => true,
      require   => File['/etc/init.d/elasticsearch'],
   }
   
   service { 'thin':
      ensure   => running,
      enable   => true,
      require   => File['/etc/init.d/thin'],
   }
}
