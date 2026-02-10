# Show current TELEPORT_HOME status and session info

function tui --description "Show current Teleport profile status"
    if not set -q TELEPORT_HOME
        echo "🔓 TELEPORT_HOME: (not set - using default ~/.tsh)"
        set -l home ~/.tsh
    else
        echo "🔐 TELEPORT_HOME: $TELEPORT_HOME"
        set -l home $TELEPORT_HOME
    end

    echo ""

    if test -f "$home/current-profile"
        set -l profile (cat "$home/current-profile")
        echo "📡 Active Profile: $profile"
        
        # Try to get cluster info
        if command -q tsh
            echo ""
            set_color yellow
            echo "Session Status:"
            set_color normal
            tsh status 2>/dev/null || echo "   Not logged in"
        end
    else
        echo "📡 No active session"
    end
end
