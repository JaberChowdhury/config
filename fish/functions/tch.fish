function tch
    set -l start_time (date +%s)

    echo (set_color cyan) "▶ Starting theme change process..."

    set -l raw_output (swww query)

    # Extract everything after 'image: ' till end of line
    set -l wallpaper (string match -r 'image: .+' -- $raw_output | string replace -r 'image: ' '' | head -n1)

    if test -z "$wallpaper"
        echo (set_color red) "✖ Could not extract wallpaper path!"
        return 1
    end

    echo (set_color green) "✔ Found wallpaper:" (set_color yellow) $wallpaper

    echo (set_color cyan) "▶ Generating theme from wallpaper..."
    if not wal -i "$wallpaper"
        echo (set_color red) "✖ wal command failed!"
        return 1
    end
    echo (set_color green) "✔ Theme generated successfully."

    echo (set_color cyan) "▶ Reloading kitty terminal colors..."
    killall -SIGUSR1 kitty
    echo (set_color green) "✔ Kitty theme reloaded."

    set -l end_time (date +%s)
    set -l elapsed (math $end_time - $start_time)

    echo (set_color magenta) "✨ Theme change completed in $elapsed seconds."
    set_color normal
end

