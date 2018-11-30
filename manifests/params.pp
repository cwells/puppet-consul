# == Class consul::params
#
# This class is meant to be called from consul
# It sets variables according to platform
#
class consul::params {
  $acls                 = {}
  $archive_path         = ''
  $bin_dir              = '/usr/local/bin'
  $checks               = {}
  $config_defaults      = {}
  $config_hash          = {}
  $config_mode          = '0664'
  $docker_image         = 'consul'
  $download_extension   = 'zip'
  $download_url_base    = 'https://releases.hashicorp.com/consul/'
  $extra_groups         = []
  $extra_options        = ''
  $group                = 'consul'
  $log_file             = '/var/log/consul'
  $install_method       = 'url'
  $join_wan             = false
  $manage_group         = true
  $manage_service       = true
  $manage_user          = true
  $package_ensure       = 'latest'
  $package_name         = 'consul'
  $pretty_config        = false
  $pretty_config_indent = 4
  $purge_config_dir     = true
  $restart_on_change    = true
  $service_enable       = true
  $service_ensure       = 'running'
  $services             = {}
  $user                 = 'consul'
  $version              = '1.4.0'
  $watches              = {}

  $arch = $facts['architecture'] ? {
    /(x86_|x|amd)64/ => 'amd64',
    'i386'           => '386',
    'aarch64'        => 'arm64',
    /^arm.*/         => 'arm',
    default          => fail("Unsupported kernel architecture: ${facts['architecture']}")

  }

  $config_dir = $facts['os']['family'] ? {
    'FreeBSD' => '/usr/local/etc/consul.d',
    'windows' => 'c:/Consul/config',
    default   => '/etc/consul'
  }

  $data_dir = '/opt/consul'
  $os = downcase($facts['kernel'])

  case $facts['os']['name'] {
    'windows': {
      $binary_group = 'Administrators'
      $binary_mode  = '0755'
      $binary_name  = 'consul.exe'
      $binary_owner = 'Administrator'
    }
    default: {
      # 0 instead of root because OS X uses "wheel".
      $binary_group = 0
      $binary_mode  = '0555'
      $binary_name  = 'consul'
      $binary_owner = 'root'
    }
  }

  $shell = $facts['os']['name'] ? {
    /Ubuntu|Debian/                     => '/usr/sbin/nologin',
    /RedHat|Archlinux|OpenSuSE|SLE[SD]/ => '/sbin/nologin',
    default                             => undef
  }

  $init_style = $facts['operatingsystem'] ? {
    'windows' => 'unmanaged',
    default   => $facts['service_provider'] ? {
      undef   => 'systemd',
      default => $facts['service_provider']
    }
  }
}
