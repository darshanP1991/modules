# == Class: ntp::service
class ntp::service inherits ntp {

  service { 'ntpd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require => Package['ntp'],
  }
}
