#!/bin/bash

(mv ~/Downloads/launch.ica /tmp && \
    /usr/lib/ICAClient/wfica /tmp/launch.ica &)
