#!/bin/sh
git submodule update --init --recursive
pip install --user --editable "git+https://github.com/jagguli/ropemacs.git#egg=ropemacs"
cd modules.d/Pymacs
make
python setup.py install --user
ln -sf ~/.emacs.d.jagguli/emacs-profiles.el .emacs-profiles.el
cd ~/
git clone https://github.com/plexus/chemacs2.git .emacs.d/

