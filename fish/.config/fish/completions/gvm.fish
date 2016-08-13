function __fish_gvm_no_command --description 'Test if gvm has yet to be given the main command'
  set cmd (commandline -opc)
  if [ (count $cmd) -eq 1 ]
    return 0
  end
  return 1
end

function __fish_gvm_using_command
  set cmd (commandline -opc)
  if [ (count $cmd) -eq 2 ]
    if [ $argv[1] = $cmd[2] ]
      return 0
    end
  end
  return 1
end

function __fish_gvm_using_subcommand
  set cmd (commandline -opc)
  set cmd_main $argv[1]
  set cmd_sub $argv[2]

  if [ (count $cmd) -gt 2 ]
    if [ $cmd_main = $cmd[2] ]; and [ $cmd_sub = $cmd[3] ]
      return 0
    end
  end
  return 1
end

function __fish_gvm_specifying_candidate
  set cmd (commandline -opc)

  if [ (count $cmd) -gt 2 ]
    if [ $argv[1] = $cmd[2] ]
      return 0
    end
  end
  return 1
end

function __fish_gvm_candidates
  cat ~/.gvm/var/candidates | tr ',' '\n'
end

function __fish_gvm_installed_versions
  set cmd (commandline -opc)
  ls -v1 ~/.gvm/$cmd[3] | grep -v current
end

# install
complete -c gvm -f -n '__fish_gvm_no_command' -a 'install' -d 'Install new version'
complete -c gvm -f -n '__fish_gvm_no_command' -a 'i' -d 'Install new version'
complete -c gvm -f -n '__fish_gvm_using_command install' -a "(__fish_gvm_candidates)"
complete -c gvm -f -n '__fish_gvm_using_command i' -a "(__fish_gvm_candidates)"

# uninstall
complete -c gvm -f -n '__fish_gvm_no_command' -a 'uninstall' -d 'Uninstall version'
complete -c gvm -f -n '__fish_gvm_no_command' -a 'rm' -d 'Uninstall version'
complete -c gvm -f -n '__fish_gvm_using_command uninstall' -a "(__fish_gvm_candidates)"
complete -c gvm -f -n '__fish_gvm_using_command rm' -a "(__fish_gvm_candidates)"
complete -c gvm -f -n '__fish_gvm_specifying_candidate uninstall' -a "(__fish_gvm_installed_versions)"
complete -c gvm -f -n '__fish_gvm_specifying_candidate rm' -a "(__fish_gvm_installed_versions)"

# list
complete -c gvm -f -n '__fish_gvm_no_command' -a 'list' -d 'List versions'
complete -c gvm -f -n '__fish_gvm_no_command' -a 'ls' -d 'List versions'
complete -c gvm -f -n '__fish_gvm_using_command list' -a "(__fish_gvm_candidates)"
complete -c gvm -f -n '__fish_gvm_using_command ls' -a "(__fish_gvm_candidates)"
complete -c gvm -f -n '__fish_gvm_specifying_candidate list' -a "(__fish_gvm_installed_versions)"
complete -c gvm -f -n '__fish_gvm_specifying_candidate ls' -a "(__fish_gvm_installed_versions)"

# use
complete -c gvm -f -n '__fish_gvm_no_command' -a 'use' -d 'Use specific version'
complete -c gvm -f -n '__fish_gvm_no_command' -a 'u' -d 'Use specific version'
complete -c gvm -f -n '__fish_gvm_using_command use' -a "(__fish_gvm_candidates)"
complete -c gvm -f -n '__fish_gvm_using_command u' -a "(__fish_gvm_candidates)"
complete -c gvm -f -n '__fish_gvm_specifying_candidate use' -a "(__fish_gvm_installed_versions)"
complete -c gvm -f -n '__fish_gvm_specifying_candidate u' -a "(__fish_gvm_installed_versions)"

# default
complete -c gvm -f -n '__fish_gvm_no_command' -a 'default' -d 'Set default version'
complete -c gvm -f -n '__fish_gvm_no_command' -a 'd' -d 'Set default version'
complete -c gvm -f -n '__fish_gvm_using_command default' -a "(__fish_gvm_candidates)"
complete -c gvm -f -n '__fish_gvm_using_command d' -a "(__fish_gvm_candidates)"
complete -c gvm -f -n '__fish_gvm_specifying_candidate default' -a "(__fish_gvm_installed_versions)"
complete -c gvm -f -n '__fish_gvm_specifying_candidate d' -a "(__fish_gvm_installed_versions)"

# current
complete -c gvm -f -n '__fish_gvm_no_command' -a 'current' -d 'Display current version'
complete -c gvm -f -n '__fish_gvm_no_command' -a 'c' -d 'Display current version'
complete -c gvm -f -n '__fish_gvm_using_command current' -a "(__fish_gvm_candidates)"
complete -c gvm -f -n '__fish_gvm_using_command c' -a "(__fish_gvm_candidates)"
complete -c gvm -f -n '__fish_gvm_specifying_candidate current' -a "(__fish_gvm_installed_versions)"
complete -c gvm -f -n '__fish_gvm_specifying_candidate c' -a "(__fish_gvm_installed_versions)"

# version
complete -c gvm -f -n '__fish_gvm_no_command' -a 'version' -d 'Display version'
complete -c gvm -f -n '__fish_gvm_no_command' -a 'v' -d 'Display version'
complete -c gvm -f -n '__fish_gvm_using_command version'
complete -c gvm -f -n '__fish_gvm_using_command v'

# broadcast
complete -c gvm -f -n '__fish_gvm_no_command' -a 'broadcast' -d 'Display broadcast message'
complete -c gvm -f -n '__fish_gvm_no_command' -a 'b' -d 'Display broadcast message'
complete -c gvm -f -n '__fish_gvm_using_command broadcast'
complete -c gvm -f -n '__fish_gvm_using_command b'

# help
complete -c gvm -f -n '__fish_gvm_no_command' -a 'help' -d 'Display broadcast message'
complete -c gvm -f -n '__fish_gvm_no_command' -a 'h' -d 'Display broadcast message'
complete -c gvm -f -n '__fish_gvm_using_command help'
complete -c gvm -f -n '__fish_gvm_using_command h'

# offline
complete -c gvm -f -n '__fish_gvm_no_command' -a 'offline' -d 'Set offline status'
complete -c gvm -f -n '__fish_gvm_using_command offline' -a 'enable disable'

# selfupdate
complete -c gvm -f -n '__fish_gvm_no_command' -a 'selfupdate' -d 'Update gvm'
complete -c gvm -f -n '__fish_gvm_using_command selfupdate' -a 'force'

# flush
complete -c gvm -f -n '__fish_gvm_no_command' -a 'flush' -d 'Clear out cache'
complete -c gvm -f -n '__fish_gvm_using_command flush' -a 'candidates broadcast archives temp'
