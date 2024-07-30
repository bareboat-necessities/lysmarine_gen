#!/bin/sh

/usr/bin/su -c '/usr/bin/systemctl is-enabled kplex && /usr/bin/systemctl reset-failed kplex && /usr/bin/systemctl restart kplex'
