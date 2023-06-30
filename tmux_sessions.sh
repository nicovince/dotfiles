#!/bin/bash
# Tmux sessions
VOG_WORKSPACE="/home/nicolas/work/siema/be/VOG/src/vog-zephyr"
tmux_vogzeph()
{
    SESSION_NAME="vog"
    tmux attach-session -d -t ${SESSION_NAME}
    ret="$?"
    if [[ "${ret}" == 0 ]]; then
        return
    fi
    tmux new-session -d -s ${SESSION_NAME}

    tmux rename-window "west"
    tmux send-keys "cd ${VOG_WORKSPACE}" C-m
    tmux send-keys "get_stm32" C-m
    tmux send-keys "workon vog_zephyr_3.2" C-m
    tmux send-keys "docker compose -f vog-zephyr-nodes/scripts/vog-cpu-emulator/mqtts-docker-compose.yml up -d" C-m

    tmux new-window -n "vim.vog"
    tmux send-keys "cd ${VOG_WORKSPACE}" C-m
    tmux send-keys "get_stm32" C-m
    tmux send-keys "workon vog_zephyr_3.2" C-m

    tmux new-window -n "git.vog"
    tmux send-keys "cd ${VOG_WORKSPACE}/vog-zephyr-nodes" C-m
    tmux send-keys "workon vog_zephyr_3.2" C-m
    tmux send-keys "source env.sh" C-m
    tmux send-keys "get_gh_completion" C-m

    tmux new-window -n "serial"
    tmux send-keys "cd ${VOG_WORKSPACE}" C-m
    tmux send-keys "picocom -b 115200 /dev/ttyACM0"

    tmux new-window -n "pytest"
    tmux send-keys "cd ${VOG_WORKSPACE}" C-m
    tmux send-keys "workon vog_zephyr_3.2" C-m
    tmux send-keys "get_stm32" C-m
    tmux send-keys "source vog-zephyr-nodes/env.sh" C-m
    tmux send-keys "pytest --verbosity 1 -k test_eth_node vog-zephyr-nodes/test/"

    tmux attach-session -t ${SESSION_NAME}
}

tmux_vog_dev()
{
    SESSION_NAME="vog-devices"
    tmux attach-session -d -t ${SESSION_NAME}
    ret="$?"
    if [[ "${ret}" == 0 ]]; then
        return
    fi
    tmux new-session -d -s ${SESSION_NAME}

    WINDOW_NAME="vog_eth@rs485"
    tmux rename-window -t ${SESSION_NAME} "${WINDOW_NAME}"
    PANE_NAME="serial"
    TARGET_WINDOW="${SESSION_NAME}:${WINDOW_NAME}"
    tmux set-option -t "${TARGET_WINDOW}" pane-border-status bottom
    tmux select-pane -T "${PANE_NAME}" -t "${TARGET_WINDOW}"
    tmux send-keys -t "${TARGET_WINDOW}" "ls /dev/serial/by-id/ -1" C-m
    tmux send-keys -t "${TARGET_WINDOW}" "picocom -b 115200 /dev/serial/by-id/"

    tmux split-window -h -t "${TARGET_WINDOW}"
    PANE_NAME="enki"
    tmux select-pane -T "${PANE_NAME}" -t ${TARGET_WINDOW}
    tmux send-keys -t "${TARGET_WINDOW}" "cd ${VOG_WORKSPACE}" C-m
    tmux send-keys -t "${TARGET_WINDOW}" "docker compose -f vog-zephyr-nodes/scripts/vog-cpu-emulator/mqtts-docker-compose.yml up -d" C-m
    tmux send-keys -t "${TARGET_WINDOW}" "enki"

    tmux attach-session -t ${SESSION_NAME}
}

ZEPHYR_WORKSPACE="/home/nicolas/work/siema/be/VOG/src/zephyrproject"
tmux_zeph()
{
    SESSION_NAME="zephyr"
    tmux attach-session -d -t ${SESSION_NAME}
    ret="$?"
    if [[ "${ret}" == 0 ]]; then
        return
    fi
    tmux new-session -d -s ${SESSION_NAME}

    tmux rename-window "west"
    tmux send-keys "cd ${ZEPHYR_WORKSPACE}" C-m
    tmux send-keys "get_stm32" C-m
    tmux send-keys "workon vog_zephyr_3.2" C-m

    tmux new-window -n "vim.zephyr"
    tmux send-keys "cd ${ZEPHYR_WORKSPACE}" C-m

    tmux new-window -n "git.zeph"
    tmux send-keys "cd ${ZEPHYR_WORKSPACE}/zephyr" C-m
    tmux send-keys "source zephyr-env.sh" C-m
    tmux send-keys "get_gh_completion" C-m
    tmux send-keys "workon vog_zephyr_3.2" C-m

    tmux new-window -n "serial"
    tmux send-keys "cd ${ZEPHYR_WORKSPACE}" C-m
    tmux send-keys "picocom -b 115200 /dev/ttyACM0"

    tmux attach-session -t ${SESSION_NAME}
}
GH_RUNNERS=/home/nicolas/work/siema/be/VOG/gh_runners
tmux_gh_runners()
{
    SESSION_NAME="gh_runners"
    tmux attach-session -d -t ${SESSION_NAME}
    ret="$?"
    if [[ "${ret}" == 0 ]]; then
        return
    fi
    tmux new-session -d -s ${SESSION_NAME}

    tmux rename-window "cfg"
    tmux send-keys "cd ${VOG_WORKSPACE}" C-m

    tmux new-window -n "siema.runner"
    tmux send-keys "cd ${GH_RUNNERS}/runner-SiemaApplications-vog-zephyr-nodes" C-m
    tmux send-keys "workon vog_zephyr_3.2" C-m
    tmux send-keys "get_stm32" C-m
    tmux send-keys "export RUNNER_BOARD_ENV=vog-zephyr-nodes/scripts/gh_runners_boards/firefly_nucleo_h743-env.sh" C-m
    tmux send-keys "./run.sh" C-m

    tmux attach-session -t ${SESSION_NAME}
}

SIAM_WORKSPACE="${HOME}/work/siema/be/Siam-ST3"
tmux_siam_i2c()
{
    SESSION_NAME="siam-i2c"
    tmux attach-session -d -t ${SESSION_NAME}
    ret="$?"
    if [[ "${ret}" == 0 ]]; then
        return
    fi
    tmux new-session -d -s ${SESSION_NAME}

    tmux rename-window "git.sd"
    tmux send-keys "cd ${SIAM_WORKSPACE}/src/siema_devices" C-m

    tmux new-window -n "vim.sd"
    tmux send-keys "cd ${SIAM_WORKSPACE}/src/siema_devices" C-m

    tmux new-window -n "mgmt.r4ip"
    tmux send-keys "cd ${SIAM_WORKSPACE}/src/r4ip-buildroot/output" C-m
    tmux send-keys "echo 'make siema_devices{-dirclean,}'" C-m
    tmux split-window -v
    tmux send-keys "cd ${SIAM_WORKSPACE}/src/r4ip-buildroot" C-m

    tmux new-window -n "tcraft"
    tmux send-keys "cd ${SIAM_WORKSPACE}/src/tboxcraft" C-m
    tmux send-keys "CC=${SIAM_WORKSPACE}/src/r4ip-buildroot/output/host/bin/powerpc-buildroot-linux-gnu-gcc make"

    tmux new-window -n "vim.tcraft"
    tmux send-keys "cd ${SIAM_WORKSPACE}/src/tboxcraft" C-m

    tmux new-window -n "git.linux"
    tmux send-keys "cd ${SIAM_WORKSPACE}/src/linux-ucc32" C-m

    tmux new-window -n "vim.linux"
    tmux send-keys "cd ${SIAM_WORKSPACE}/src/linux-ucc32" C-m

    tmux attach-session -t ${SESSION_NAME}
}

tmux_r4ip()
{
    local suffix="$1"
    if [ -z "${suffix}" ]; then
        suffix="-1"
    fi
    SESSION_NAME="build-r4ip${suffix}"
    R4IP_DIR="$(pwd)"

    tmux attach-session -d -t ${SESSION_NAME}
    ret="$?"
    if [[ "${ret}" == 0 ]]; then
        return
    fi
    tmux new-session -d -s ${SESSION_NAME}

    tmux rename-window "mgmt.r4ip"
    tmux send-keys "cd ${R4IP_DIR}/output" C-m
    tmux split-window -v
    tmux send-keys "cd ${R4IP_DIR}" C-m

    tmux new-window -n "vim.r4ip"
    tmux send-keys "cd ${R4IP_DIR}" C-m

    tmux new-window -n "git.sd"
    tmux send-keys "cd ${SIAM_WORKSPACE}/src/siema_devices" C-m

    tmux new-window -n "vim.sd"
    tmux send-keys "cd ${SIAM_WORKSPACE}/src/siema_devices" C-m

    tmux new-window -n "tcraft"
    tmux send-keys "cd ${SIAM_WORKSPACE}/src/tboxcraft" C-m
    tmux send-keys "CC=${SIAM_WORKSPACE}/src/r4ip-buildroot/output/host/bin/powerpc-buildroot-linux-gnu-gcc make"

    tmux new-window -n "vim.tcraft"
    tmux send-keys "cd ${SIAM_WORKSPACE}/src/tboxcraft" C-m

    tmux new-window -n "git.linux"
    tmux send-keys "cd ${SIAM_WORKSPACE}/src/linux-ucc32" C-m

    tmux new-window -n "vim.linux"
    tmux send-keys "cd ${SIAM_WORKSPACE}/src/linux-ucc32" C-m

    tmux attach-session -d -t ${SESSION_NAME}
}
