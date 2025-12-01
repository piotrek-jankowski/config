#!/usr/bin/env bash
# Based on Rubem Pacelli's answer onn:
# https://askubuntu.com/questions/1404497/how-to-install-gnome-shell-extensions-in-ubuntu-22-04-lts

### GNOME extensions ###
# Loop through each arg
for url in "$@"; do
  echo "url = ${url}"
  # get package metadata
  id=$(echo "${url}" | cut --delimiter=/ --fields=5)
  url_pkg_metadata="https://extensions.gnome.org/extension-info/?pk=${id}"
  # Extract data for each extension
  uuid=$(curl -s "$url_pkg_metadata" | jq -r '.uuid' | tr -d '@')
  latest_extension_version=$(curl -s "$url_pkg_metadata" | jq -r '.shell_version_map | to_entries | max_by(.value.version) | .value.version')
  latest_shell_version=$(curl -s "$url_pkg_metadata" | jq -r '.shell_version_map | to_entries | max_by(.value.version) | .key')

  # get  package
  filename="${uuid}.v${latest_extension_version}.shell-extension.zip"
  url_pkg="https://extensions.gnome.org/extension-data/${filename}"
  wget -P /tmp "${url_pkg}"
  # install package
  gnome-extensions install "/tmp/${filename}"

  # Print the results
  echo "For URL: $url"
  echo "UUID: $uuid"
  echo "Latest extension version: $latest_extension_version"
  echo "Latest shell version: $latest_shell_version"
  echo "--------------------------------------"
done
