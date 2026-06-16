POWER_PROFILE="$(powerprofilesctl get)"

if [ $POWER_PROFILE = "performance" ]; then
    powerprofilesctl set power-saver
fi

if [ $POWER_PROFILE = "balanced" ]; then
    powerprofilesctl set performance
fi

if [ $POWER_PROFILE = "power-saver" ]; then
    powerprofilesctl set balanced
fi
