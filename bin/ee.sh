#!/bin/sh -x
name=`basename $0`
# emacs st-color is not yet ready ?
export TERM='xterm-256color'
tmux_name=`tmux display-message -p '#W'`
tmux rename-window $name
emacsclient -f $name --eval '(setenv "TMUX" "'$TMUX'")'
emacsclient -f $name --eval '(setenv "TERM" "'$TERM'")'
emacsclient -f $name $@
tmux rename-window $tmux_name
