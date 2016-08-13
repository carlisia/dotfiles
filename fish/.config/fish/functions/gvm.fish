function gvm
	set after_env (mktemp -t env)
	set path_env (mktemp -t env)

    bash -c "source ~/.gvm/bin/gvm-init.sh && gvm $argv && printenv > $after_env"

    # remove any pre-existing .gvm paths
    for elem in $PATH
    	switch $elem
    		case '*/.gvm/*'
    			# ignore
    		case '*'
    			echo "$elem" >> $path_env
    	end
    end

    for env in (cat $after_env)
    	set env_name (echo $env | sed s/=.\*//)
    	set env_value (echo $env | sed s/.\*=//)
    	switch $env_name
    		case 'PATH'
    			for elem in (echo $env_value | tr ':' '\n')
    				switch $elem
    					case '*/.gvm/*'
    						echo "$elem" >> $path_env
    				end
    			end
    		case '*'
    			switch $env_value
    				case '*/.gvm/*'
		    			eval set -g $env_name $env_value > /dev/null
    			end
    	end
    end
    set -gx PATH (cat $path_env) ^ /dev/null

    rm -f $after_env
    rm -f $path_env
end
