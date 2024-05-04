alias cls='clear'
alias ll='ls -lah'
alias thermal='while true; do; echo -e -n "CPU Temp: $[$(cat /sys/class/thermal/thermal_zone0/temp)/1000] C\r"; sleep 0.2; done;'
alias jnb="jupyter notebook --no-browser --port 8888 --ip 0.0.0.0 > jnb_log.txt 2>&1 &"

