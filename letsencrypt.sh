#!/bin/bash
grep  "/etc/letsencrypt/live/stream.noordzee105.be/fullchain.pem expires on" /var/log/letsencrypt/letsencrypt.log | tail -1

 /etc/letsencrypt/live/stream.noordzee105.be/fullchain.pem expires on 

grep  "/etc/letsencrypt/live/kerst.noordzee105.be/fullchain.pem expires on" /var/log/letsencrypt/letsencrypt.log | tail -1


