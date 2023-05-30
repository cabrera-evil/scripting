#!/bin/bash

# Add "OnlyShowIn=GNOME" to GNOME desktop files
find /usr/share/applications/org.gnome.*.desktop -exec bash -c 'echo "OnlyShowIn=GNOME" >> {}' \;

# Add "OnlyShowIn=KDE" to KDE desktop files
find /usr/share/applications/org.kde.*.desktop -exec bash -c 'echo "OnlyShowIn=KDE" >> {}' \;
