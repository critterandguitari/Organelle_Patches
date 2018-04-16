jackd -R -P90 -p16 -t200 -d alsa -dhw:0 -p 128 -r 44100 -s -i2 -o2 & echo $! > /tmp/pids/jack.pid
