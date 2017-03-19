#!/bin/bash
echo "Building from travis"

export NUMPY=numpy
export OPENBLAS_NUM_THREADS=1
export PANDAS=
export NPROC=2
export INSTALL_PEP8=
export RUN_PEP8=
export PYTEST_ARGS="-ra --maxfail=1 --timeout=300 --durations=25 --cov-report= --cov=lib -n $NPROC"
export PYTHON_ARGS=
export DELETE_FONT_CACHE=
export MOCK=
export BUILD_DOCS=true

# Addons
apt-get update -qy
apt-get install -qy inkscape
apt-get install -qy libav-tools
apt-get install -qy gdb
apt-get install -qy mencoder
apt-get install -qy dvipng
apt-get install -qy pgf
apt-get install -qy lmodern
apt-get install -qy cm-super
apt-get install -qy texlive-latex-base
apt-get install -qy texlive-latex-extra
apt-get install -qy texlive-fonts-recommended
apt-get install -qy texlive-latex-recommended
apt-get install -qy texlive-xetex
apt-get install -qy graphviz
apt-get install -qy libgeos-dev
apt-get install -qy otf-freefont

pip install --upgrade virtualenv

# Remove old venv
rm -rf venv
python -m virtualenv venv
source venv/bin/activate
# Install
pip install --upgrade pip
pip install --upgrade wheel
pip install --upgrade setuptools
## install deps from pypi
pip install $PRE python-dateutil $NUMPY pyparsing!=2.1.6 $PANDAS cycler codecov coverage $MOCK
pip install $PRE -r doc-requirements.txt

# pytest-cov>=2.3.1 due to https://github.com/pytest-dev/pytest-cov/issues/124
pip install $PRE pytest 'pytest-cov>=2.3.1' pytest-timeout pytest-xdist pytest-faulthandler $INSTALL_PEP8

if [[ $BUILD_DOCS == true ]]; then
  wget https://github.com/google/fonts/blob/master/ofl/felipa/Felipa-Regular.ttf?raw=true -O Felipa-Regular.ttf
  wget http://mirrors.kernel.org/ubuntu/pool/universe/f/fonts-humor-sans/fonts-humor-sans_1.0-1_all.deb
  mkdir -p tmp
  mkdir -p ~/.fonts
  dpkg -x fonts-humor-sans_1.0-1_all.deb tmp
  cp tmp/usr/share/fonts/truetype/humor-sans/Humor-Sans.ttf ~/.fonts
  cp Felipa-Regular.ttf ~/.fonts
  fc-cache -f -v
else
  # Use the special local version of freetype for testing
  cp ci/travis/setup.cfg .
fi;

# Install matplotlib
pip install -ve .

cd doc
# python make.py html -n 2
python -msphinx . build/xml -j2 -bxml
