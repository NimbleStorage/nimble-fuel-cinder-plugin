notice('MODULAR: nimble-disable-default-volume-type')

include plugin_cinder_nimble::params
include cinder::params

$config_file = '/etc/cinder/cinder.conf'
$cinder_nimble = hiera_hash('cinder_nimble', {})

define plugin_cinder_nimble::check_if_default_type_is_enabled (
) {
  if (($cinder_nimble["nimble${name}_default_backend"]) == true) and
     (($cinder_nimble["nimble${name}_backend_type"]) != '') {
    class { 'plugin_cinder_nimble::backend::disable_default_type' :
      config_file => $config_file,
    }
  }
}

if ($cinder_nimble['nimble_grouping']) == true {
  if (($cinder_nimble['nimble_group_default_backend']) == true) and
     (($cinder_nimble["nimble_group_backend_type"]) != '') {
    class { 'plugin_cinder_nimble::backend::disable_default_type' :
      config_file => $config_file,
    }
  }
}
else {
  # Should work from Puppet >= 4.0.0 onwards which has Future parser
  /*
  range("1", "$cinder_nimble['no_backends']").each |Integer $index, String $value| {
    if ($cinder_nimble["nimble${value}_default_backend"]) == true {
      $nimble_default_type_set = true
    }
  }
  */

  $range_array = range("1", $cinder_nimble['no_backends'])
  plugin_cinder_nimble::check_if_default_type_is_enabled { $range_array: }
}
