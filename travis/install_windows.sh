#!/usr/bin/env bash

# Install build dependencies on Windows
#
# Required Environment Variables:
# - PYVERSIONS is a space-delimited string of Python versions to install with
#   NuGet
# - PYINSTALL_DIR is the directory where Python instances are installed
# - CYTHON_VERSION is the version of Cython to install

set -euxo pipefail

# Visual Studio 2019
choco install visualstudio2019buildtools --limit-output --package-parameters "--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --quiet"

# buildcache
if ! [ -f "$BUILDCACHE_EXE_DIR/iknow_buildcache_url.txt" ] || [ $(cat "$BUILDCACHE_EXE_DIR/iknow_buildcache_url.txt") != "$BUILDCACHE_URL" ]; then
  rm -rf "$BUILDCACHE_EXE_DIR"
  wget -nv -O buildcache.zip "$BUILDCACHE_URL"
  unzip -qj buildcache.zip -d "$BUILDCACHE_EXE_DIR"
  echo "$BUILDCACHE_URL" > "$BUILDCACHE_EXE_DIR/iknow_icu_url.txt"
fi

# Python
choco install nuget.commandline --limit-output
if [ -d "$PYINSTALL_DIR" ]; then
  # delete unused Python versions from cache
  cd "$PYINSTALL_DIR"
  for PYINSTALLATION in *; do
    [ -d "$PYINSTALLATION" ] || continue
    if ! [[ "$PYVERSIONS" == *"${PYINSTALLATION#python.}"* ]]; then
      rm -rf "$PYINSTALLATION"
    fi
  done
  cd -
fi
for PYVERSION in $PYVERSIONS; do
  nuget.exe install python -Version "$PYVERSION" -NonInteractive -Verbosity quiet -OutputDirectory "$PYINSTALL_DIR"
done

# Python packages
for PYTHON in "$PYINSTALL_DIR"/python.*/tools/python.exe; do
  "$PYTHON" -m pip install -U pip
  "$PYTHON" -m pip install -U cython=="$CYTHON_VERSION" setuptools wheel --no-warn-script-location
done
