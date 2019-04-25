function kubectl_status
  
  if test -z "$__kube_ps_enabled"; or test $__kube_ps_enabled -ne 1
    return
  end
  
  [ -z "$KUBECTL_PROMPT_ICON" ]; and set -l KUBECTL_PROMPT_ICON "⎈"
  [ -z "$KUBECTL_PROMPT_SEPARATOR" ]; and set -l KUBECTL_PROMPT_SEPARATOR "|"
  set -l config $KUBECONFIG
  [ -z "$config" ]; and set -l config "$HOME/.kube/config"
  if [ ! -f $config ]
    echo (set_color red)$KUBECTL_PROMPT_ICON" "(set_color white)"no config"
    return
  end

  set -l context (kubectl config current-context 2>/dev/null)
  if [ $status -ne 0 ]
    echo (set_color red)$KUBECTL_PROMPT_ICON" "(set_color white)"no context"
    return
  end

  set -l ns (kubectl config view -o "jsonpath={.contexts[?(@.name==\"$context\")].context.namespace}")
  [ -z $ns ]; and set -l ns 'default'

  echo (set_color blue)$KUBECTL_PROMPT_ICON" "(set_color cyan)"($context"(set_color white)"$KUBECTL_PROMPT_SEPARATOR"(set_color yellow)"$ns)"
end
