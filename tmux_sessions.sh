#!/bin/bash

VOG_WORKSPACE="/home/nicolas/work/siema/be/VOG/src/vog-zephyr"
tmux_zeph()
{
    SESSION_NAME="zephyr"
    tmux attach-session -d -t ${SESSION_NAME}
    if [[ $? == 0 ]]; then
        return
    fi
    tmux new-session -d -s ${SESSION_NAME}

    tmux rename-window "west"
    tmux send-keys "cd ${VOG_WORKSPACE}" C-m
    tmux send-keys "workon zephyr" C-m

    tmux new-window -n "vim.vog"
    tmux send-keys "cd ${VOG_WORKSPACE}" C-m

    tmux new-window -n "git.vog"
    tmux send-keys "cd ${VOG_WORKSPACE}/vog-zephyr-nodes" C-m
    tmux send-keys "source ../zephyr/zephyr-env.sh" C-m

    tmux new-window -n "git.zeph"
    tmux send-keys "cd ${VOG_WORKSPACE}/zephyr" C-m
    tmux send-keys "source ../zephyr/zephyr-env.sh" C-m

    tmux new-window -n "serial"
    tmux send-keys "cd ${VOG_WORKSPACE}" C-m
    tmux send-keys "screen /dev/ttyACM0 115200 8N1"

    tmux attach-session -t ${SESSION_NAME}
}

GH_RUNNERS=/home/nicolas/work/siema/be/VOG/gh_runners/runner-nvincent-vossloh-vog-zephyr-nodes
tmux_gh_runners()
{
    SESSION_NAME="gh_runners"
    tmux attach-session -d -t ${SESSION_NAME}
    if [[ $? == 0 ]]; then
        return
    fi
    tmux new-session -d -s ${SESSION_NAME}

    tmux rename-window "cfg"
    tmux send-keys "cd ${VOG_WORKSPACE}" C-m

    tmux new-window -n "nvi.runner"
    tmux send-keys "cd ${GH_RUNNER}/runner-nvincent-vossloh-vog-zephyr-nodes" C-m
    tmux send-keys "workon zephyr_test"
    tmux send-keys "./run.sh" C-m
}
