# Steam-Nvidia-On-Headless-Server
Running steam for gaming on headless server






docker build -t steam-headless .


docker run --runtime=nvidia -it --privileged -p 8083:8083 -p 27015-27030:27015-27030 -p 27015-27030:27015-27030/udp -p 4380:4380 -p 3478:3478/udp -p 4379:4379/udp -v /run/dbus:/run/dbus:ro --tmpfs /var/run/dbus -v /home/container_data:/home/steam/data my-steam-container
