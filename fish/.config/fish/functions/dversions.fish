# Quick version check - all dev binaries (dev builds + release installs)
function dversions
    set -l build_dir ~/code/src/github.com/gravitational/teleport/build
    echo "=== Dev Builds ==="
    for bin in teleport tsh tctl tbot
        if test -f "$build_dir/$bin"
            printf "%-10s %s\n" "$bin:" ("$build_dir/$bin" version 2>/dev/null | command head -1)
        else
            printf "%-10s %s\n" "$bin:" "(not built)"
        end
    end
    echo ""
    echo "=== Release Versions ==="
    for bin in teleport tsh tctl tbot
        if type -q $bin
            printf "%-10s %s\n" "$bin:" ($bin version 2>/dev/null | command head -1)
        else
            printf "%-10s %s\n" "$bin:" "(not installed)"
        end
    end
end
