# R Midhun Suresh 
# Simple monitor mode manager that cycles through three modes.


# Execute xrandr command and store result in variable.
XRANDR_OUTPUT=$(xrandr)

#First make sure that there are two displays available.
if echo $XRANDR_OUTPUT | grep -o -q "HDMI-1-1 disconnected";then
    echo "ERROR:Only primary display found."
    $(notify-send  -t 1500 "Only Primary Display Found.")
    exit 1
fi

# Run grep to see if eDP-1-1 is connected.
# If a particular display device is connected
# then there will be a number after "display_id connected"
if echo $XRANDR_OUTPUT | grep -o -q "eDP-1-1 connected[[:space:]][[:digit:]]";then
    echo "eDP-1-1 (Laptop Monitor) is switched on."
    EDP_ON=true
else
    echo "eDP-1-1 (Laptop Monitor) is switched off."
fi

#Do the same for HDMI monitor
if echo $XRANDR_OUTPUT | grep -o -q "HDMI-1-1 connected[[:space:]][[:digit:]]";then
    echo "HDMI-1-1 (Laptop Monitor) is switched on."
    HDMI_ON=true
else
    echo "HDMI-1-1 (Laptop Monitor) is switched off."
fi

#Our order of monitor alignemnts is:
# EDP_ONLY -> HDMI_ONLY -> EDEP left & HDMI right
if [ "$HDMI_ON" = true ] && [ "$EDP_ON" = true ];then
    echo "Both monitors are on."
    echo "Switching to EDP only"
    $(xrandr --output HDMI-1-1 --off)
    $(notify-send -t 1500 "EDP Only Mode Enabled")

elif [ "$HDMI_ON" = true ];then
    echo "HDMI is only on."
    echo "Switching to dual monitor mode"
    $(xrandr --output eDP-1-1 --auto --left-of HDMI-1-1)
    $(notify-send -t 1500 "Dual Monitor Mode Enabled")

elif [ "$EDP_ON" = true ];then
    echo "EDP is only on"
    echo "Switching to HDMI only"
    $(xrandr --output eDP-1-1 --off)
    $(xrandr --output HDMI-1-1 --auto)
    $(notify-send -t 1500 "HDMI Only Mode Enabled")
fi
