if status is-interactive
    # Commands to run in interactive sessions can go here
 starship init fish | source   

end

# Created by `pipx` on 2025-07-27 08:27:13
set PATH $PATH /home/jaber/.local/bin

# pnpm
set -gx PNPM_HOME "/home/jaber/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
