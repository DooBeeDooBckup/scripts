#!/bin/bash

/opt/letsencrypt.sh > output.log

mail -s "Letencrypt checker:" alain.seys@vanmarcke.be < output.log
