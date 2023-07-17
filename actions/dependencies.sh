# This file is used as a central location for managing build-time dependencies.
#
# Usage: actions/dependencies.sh

set -euxo pipefail


# If you add a variable to or remove a variable from the dependency-autoupdate
# section manually, you may also need to edit the EXPECTED_VARNAMES dictionary
# in actions/updatelib.py.

# START DEPENDENCY-AUTOUPDATE SECTION
ICU_NAME="ICU 73.2"
ICU_URL_WIN=https://github.com/unicode-org/icu/releases/download/release-73-2/icu4c-73_2-Win64-MSVC2019.zip
ICU_URL_SRC=https://github.com/unicode-org/icu/releases/download/release-73-2/icu4c-73_2-src.tgz
JSON_VERSION=3.11.2
JSON_URL=https://github.com/nlohmann/json/releases/download/v3.11.2/include.zip
PYVERSIONS_WIN="3.7.9 3.8.10 3.9.13 3.10.11 3.11.4"
PYVERSIONS_MACOSUNIVERSAL="3.8.10 3.9.13 3.10.11 3.11.4"
PYURLS_MACOSUNIVERSAL="https://www.python.org/ftp/python/3.8.10/python-3.8.10-macos11.pkg https://www.python.org/ftp/python/3.9.13/python-3.9.13-macos11.pkg https://www.python.org/ftp/python/3.10.11/python-3.10.11-macos11.pkg https://www.python.org/ftp/python/3.11.4/python-3.11.4-macos11.pkg"
CCACHE_VERSION=4.8.2
CCACHE_URL=https://github.com/ccache/ccache/releases/download/v4.8.2/ccache-4.8.2-windows-x86_64.zip
CYTHON_VERSION=0.29.36
MANYLINUX2014_X86_64_TAG=2023-07-14-55e4124
MANYLINUX2014_AARCH64_TAG=2023-07-14-55e4124
MANYLINUX2014_PPC64LE_TAG=2023-07-14-55e4124
# END DEPENDENCY-AUTOUPDATE SECTION


# International Components for Unicode
if [ "$RUNNER_OS" = Windows ]; then
  # URL to .zip pre-built release of ICU for Windows x86_64
  echo "ICU_URL=$ICU_URL_WIN" >> $GITHUB_ENV
else
  # URL to .zip source release of ICU
  echo "ICU_URL=$ICU_URL_SRC" >> $GITHUB_ENV
fi

# JSON for Modern C++
echo "JSON_URL=$JSON_URL" >> $GITHUB_ENV

# Python versions
# Availability of certain versions can differ between NuGet and python.org.
if [ "$RUNNER_OS" = Windows ]; then
  # space-delimited Python versions to install with NuGet, old to new
  echo "PYVERSIONS=$PYVERSIONS_WIN" >> $GITHUB_ENV
elif [ "$RUNNER_OS" = macOS ] && [ "$GITHUB_JOB" = macos_10_9_universal ]; then
  # space-delimited Python versions to install from python.org, old to new
  echo "PYVERSIONS=$PYVERSIONS_MACOSUNIVERSAL" >> $GITHUB_ENV
  echo "PYURLS=$PYURLS_MACOSUNIVERSAL" >> $GITHUB_ENV
fi

# ccache
if [ "$RUNNER_OS" = Windows ]; then
  # URL to .zip release of ccache
  echo "CCACHE_URL=$CCACHE_URL" >> $GITHUB_ENV
fi


# set other variables that will be needed in later steps
echo "CYTHON_VERSION=$CYTHON_VERSION" >> $GITHUB_ENV
echo "MANYLINUX2014_X86_64_TAG=$MANYLINUX2014_X86_64_TAG" >> $GITHUB_ENV
echo "MANYLINUX2014_AARCH64_TAG=$MANYLINUX2014_AARCH64_TAG" >> $GITHUB_ENV
echo "MANYLINUX2014_PPC64LE_TAG=$MANYLINUX2014_PPC64LE_TAG" >> $GITHUB_ENV
