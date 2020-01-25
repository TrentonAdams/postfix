#!/usr/bin/bash

# support example.com by default for testing purposes.
echo "configuring example.com" | logger
postconf -e mydomain=example.com || 
    { echo mydomain=example.com failed; exit 1; }
postconf -e mydestination=example.com || 
    { echo mydestination=example.com failed; exit 1; }
