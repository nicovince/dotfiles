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
    tmux send-keys "workon zephyr" C-m
    tmux send-keys "source ../zephyr/zephyr-env.sh" C-m
    tmux send-keys "workon zephyr" C-m

    tmux new-window -n "git.zeph"
    tmux send-keys "cd ${VOG_WORKSPACE}/zephyr" C-m
    tmux send-keys "source ../zephyr/zephyr-env.sh" C-m
    tmux send-keys "workon zephyr" C-m

    tmux new-window -n "serial"
    tmux send-keys "cd ${VOG_WORKSPACE}" C-m
    tmux send-keys "screen /dev/ttyACM0 115200 8N1"

    tmux new-window -n "pytest"
    tmux send-keys "cd ${VOG_WORKSPACE}" C-m
    tmux send-keys "workon zephyr_test" C-m
    tmux send-keys "get_stm32" C-m
    tmux send-keys "export PYTHONPATH=${PYTHONPATH}:$(pwd)/tools/enki:$(pwd)/tools/enki/tahu/client_libraries/python/:$(pwd)/vog-zephyr-nodes/scripts" C-m
    tmux send-keys "pytest --verbosity 1 -k test_eth_node vog-zephyr-nodes/test/" C-m

    tmux attach-session -t ${SESSION_NAME}
}

GH_RUNNERS=/home/nicolas/work/siema/be/VOG/gh_runners
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

    tmux new-window -n "siema.runner"
    tmux send-keys "cd ${GH_RUNNERS}/runner-SiemaApplications-vog-zephyr-nodes" C-m
    tmux send-keys "workon zephyr_test" C-m
    tmux send-keys "get_stm32" C-m
    tmux send-keys "export RUNNER_BOARD_ENV=vog-zephyr-nodes/scripts/gh_runners_boards/firefly_nucleo_h743-env.sh" C-m
    tmux send-keys "./run.sh" C-m
}
