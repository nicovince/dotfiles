#!/bin/bash
# Tmux sessions
_tmux_vog()
{
    sn="$1"
    ws="$2"
    SESSION_NAME="${sn}"
    tmux attach-session -d -t "${SESSION_NAME}"
    ret="$?"
    if [[ "${ret}" == 0 ]]; then
        return
    fi
    tmux new-session -d -s "${SESSION_NAME}"

    tmux rename-window "west"
    tmux send-keys "cd ${ws}" C-m
    tmux send-keys "get_stm32" C-m
    tmux send-keys "workon vog_zephyr_3.4" C-m
    tmux send-keys "echo docker compose -f vog-zephyr-nodes/scripts/vog-cpu-emulator/mqtts-docker-compose.yml up -d" C-m

    tmux new-window -n "vim.vog"
    tmux send-keys "cd ${ws}" C-m
    tmux send-keys "get_stm32" C-m
    tmux send-keys "workon vog_zephyr_3.4" C-m

    tmux new-window -n "git.vog"
    tmux send-keys "cd ${ws}/vog-zephyr-nodes" C-m
    tmux send-keys "workon vog_zephyr_3.4" C-m
    tmux send-keys "source env.sh" C-m
    tmux send-keys "get_gh_completion" C-m

    tmux new-window -n "pytest"
    tmux send-keys "cd ${ws}" C-m
    tmux send-keys "workon vog_zephyr_3.4" C-m
    tmux send-keys "get_stm32" C-m
    tmux send-keys "source vog-zephyr-nodes/env.sh" C-m

    tmux attach-session -t "${SESSION_NAME}"
}

VOG_WORKSPACE="/home/nicolas/work/siema/be/VOG/src/vog-zephyr"
VOG_SN="vog"
VOG_BIS_WORKSPACE="/home/nicolas/work/siema/be/VOG/src/vog-zephyr-bis"
VOG_BIS_SN="vog2"
tmux_vog()
{
    _tmux_vog "${VOG_SN}" "${VOG_WORKSPACE}"
}

tmux_vog2()
{
    _tmux_vog "${VOG_BIS_SN}" "${VOG_BIS_WORKSPACE}"
}

# shellcheck disable=SC2139
alias _tmux_vog_bis="tmux new-session -s ${VOG_SN}-bis -t ${VOG_SN}"

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

    tmux attach-session -t "${SESSION_NAME}"
}

ZEPHYR_WORKSPACE="/home/nicolas/work/siema/be/VOG/src/zephyrproject"
tmux_zeph()
{
    SESSION_NAME="zephyr"
    tmux attach-session -d -t "${SESSION_NAME}"
    ret="$?"
    if [[ "${ret}" == 0 ]]; then
        return
    fi
    tmux new-session -d -s "${SESSION_NAME}"

    tmux rename-window "west"
    tmux send-keys "cd ${ZEPHYR_WORKSPACE}" C-m
    tmux send-keys "get_stm32" C-m
    tmux send-keys "workon vog_zephyr_3.4" C-m

    tmux new-window -n "vim.zephyr"
    tmux send-keys "cd ${ZEPHYR_WORKSPACE}" C-m

    tmux new-window -n "git.zeph"
    tmux send-keys "cd ${ZEPHYR_WORKSPACE}/zephyr" C-m
    tmux send-keys "source zephyr-env.sh" C-m
    tmux send-keys "get_gh_completion" C-m
    tmux send-keys "workon vog_zephyr_3.4" C-m

    tmux new-window -n "serial"
    tmux send-keys "cd ${ZEPHYR_WORKSPACE}" C-m
    tmux send-keys "picocom -b 115200 /dev/ttyACM0"

    tmux attach-session -t "${SESSION_NAME}"
}
GH_RUNNERS=/home/nicolas/work/siema/be/VOG/gh_runners
tmux_gh_runners()
{
    SESSION_NAME="gh_runners"
    tmux attach-session -d -t "${SESSION_NAME}"
    ret="$?"
    if [[ "${ret}" == 0 ]]; then
        return
    fi
    tmux new-session -d -s "${SESSION_NAME}"

    tmux rename-window "cfg"
    tmux send-keys "cd ${VOG_WORKSPACE}" C-m

    tmux new-window -n "siema.runner"
    tmux send-keys "cd ${GH_RUNNERS}/runner-SiemaApplications-vog-zephyr-nodes" C-m
    tmux send-keys "workon vog_zephyr_3.4" C-m
    tmux send-keys "get_stm32" C-m
    tmux send-keys "export RUNNER_BOARD_ENV=vog-zephyr-nodes/scripts/gh_runners_boards/firefly_nucleo_h743-env.sh" C-m
    tmux send-keys "./run.sh" C-m

    tmux attach-session -t "${SESSION_NAME}"
}

SIAM_WORKSPACE="${HOME}/work/siema/be/Siam-ST3"
tmux_siam_i2c()
{
    SESSION_NAME="siam-i2c"
    tmux attach-session -d -t "${SESSION_NAME}"
    ret="$?"
    if [[ "${ret}" == 0 ]]; then
        return
    fi
    tmux new-session -d -s "${SESSION_NAME}"

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

    tmux attach-session -t "${SESSION_NAME}"
}

tmux_r4ip()
{
    local suffix="$1"
    if [ -z "${suffix}" ]; then
        suffix="-1"
    fi
    SESSION_NAME="build-r4ip${suffix}"
    R4IP_DIR="$(pwd)"

    tmux attach-session -d -t "${SESSION_NAME}"
    ret="$?"
    if [[ "${ret}" == 0 ]]; then
        return
    fi
    tmux new-session -d -s "${SESSION_NAME}"

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

    tmux attach-session -d -t "${SESSION_NAME}"
}

ANYR_WORKSPACE="/home/nicolas/work/siema/be/BT-GSMR/anyr"
tmux_anyr_esp32()
{
    SESSION_NAME="anyr"
    tmux attach-session -d -t "${SESSION_NAME}"
    ret="$?"
    if [[ "${ret}" == 0 ]]; then
        return
    fi
    tmux new-session -d -s "${SESSION_NAME}"
    tmux rename-window "git.esp32"
    tmux send-keys "cd ${ANYR_WORKSPACE}/anyr-esp32/anyr" C-m

    tmux new-window -n "vim.esp32"
    tmux send-keys "cd ${ANYR_WORKSPACE}/anyr-esp32/" C-m

    tmux new-window -n "build.esp32"
    tmux send-keys "cd ${ANYR_WORKSPACE}/anyr-esp32/anyr" C-m
    tmux send-keys ". ../esp-idf/export.sh" C-m

    tmux new-window -n "vim.mitm"
    tmux send-keys "cd ${ANYR_WORKSPACE}/anyr-i2s-mitm" C-m

    tmux new-window -n "git.mitm"
    tmux send-keys "cd ${ANYR_WORKSPACE}/anyr-i2s-mitm" C-m
    tmux send-keys "get_gh_completion" C-m

    tmux new-window -n "SERIAL"
    tmux send-keys "cd ${ANYR_WORKSPACE}" C-m
    tmux split-window -h
    tmux send-keys "cd ${ANYR_WORKSPACE}/anyr-i2s-mitm" C-m
    tmux split-window -v
    tmux send-keys "cd ${ANYR_WORKSPACE}/anyr-esp32/anyr" C-m
    tmux send-keys ". ../esp-idf/export.sh" C-m
    tmux send-keys "idf.py -p /dev/ttyUSB0 flash && picocom -b 115200 /dev/ttyUSB0"
}

tmux_labgrid()
{
    SESSION_NAME="labgrid"
    tmux attach-session -d -t "${SESSION_NAME}"
    ret="$?"
    if [[ "${ret}" == 0 ]]; then
        return
    fi

    tmux new-window -n "lg.exporter"
    tmux send-keys "cd ${VOG_WORKSPACE}" C-m
    tmux send-keys "workon labgrid" C-m
    tmux send-keys "./vog-zephyr-nodes/scripts/labgrid_fill_probe_index.py vog-zephyr-nodes/test/labgrid/exporter-firefly.yaml > vog-zephyr-nodes/test/labgrid/patched_exporter-firefly.yaml" C-m
    tmux send-keys "labgrid-exporter vog-zephyr-nodes/test/labgrid/patched_exporter-firefly.yaml --hostname firefly.local" C-m

    tmux new-window -n "lg.client"
    tmux send-keys "cd ${VOG_WORKSPACE}" C-m
    tmux send-keys "workon labgrid" C-m
    tmux send-keys "source vog-zephyr-nodes/env.sh" C-m
}

LG_COORD_WORKSPACE="/home/nicolas/work/siema/be/src/labgrid"
tmux_launch_tnm_tools()
{
    SESSION_NAME="tnm-tools"

    tmux attach-session -d -t "${SESSION_NAME}"
    ret="$?"
    if [[ "${ret}" == 0 ]]; then
        return
    fi
    tmux new-session -d -s "${SESSION_NAME}"
    tmux rename-window "lg.coord"
    tmux send-keys "cd ${LG_COORD_WORKSPACE}" C-m
    tmux send-keys "source ${LG_COORD_WORKSPACE}/crossbar-venv/bin/activate" C-m
    tmux send-keys "crossbar start --config my-config.yaml" C-m

    tmux new-window -n "excalidraw"
    tmux send-keys "docker run --rm -it --name excalidraw -p 5000:80 excalidraw/excalidraw:latest" C-m

    tmux new-window -n "drawio"
    tmux send-keys "docker run -it --rm --name=\"draw\" -p 8080:8080 -p 8443:8443 jgraph/drawio" C-m
}

PM_DB_WORKSPACE="/home/nicolas/work/siema/be/PM-DB/src/pm-diagbox-embedded"
tmux_pmdb()
{
    SESSION_NAME="pm-db"

    tmux attach-session -d -t "${SESSION_NAME}"
    ret="$?"
    if [[ "${ret}" == 0 ]]; then
        return
    fi
    tmux new-session -d -s "${SESSION_NAME}"
    tmux rename-window "git.pm-db"
    tmux send-keys "cd ${PM_DB_WORKSPACE}" C-m

    tmux new-window -n "vim.pm-db"
    tmux send-keys "cd ${PM_DB_WORKSPACE}" C-m
}

TNM_WORKSPACE="/home/nicolas/work/siema/be/Outils-Methodes"
LOONY_WORKSPACE="/home/nicolas/work/siema/be/Outils-Methodes/src/loony-tools/"
VOSSLOH_GH_ACTIONS="/home/nicolas/work/siema/be/Outils-Methodes/src/vossloh-gh-actions"
tmux_tnm()
{
    SESSION_NAME="tnm"

    tmux attach-session -d -t "${SESSION_NAME}"
    ret="$?"
    if [[ "${ret}" == 0 ]]; then
        return
    fi
    tmux new-session -d -s "${SESSION_NAME}"
    tmux rename-window "git.tnm"
    tmux send-keys "cd ${TNM_WORKSPACE}/src/outils-methodes" C-m

    tmux new-window -n "vim.tnm"
    tmux send-keys "cd ${TNM_WORKSPACE}/src/outils-methodes" C-m

    tmux new-window -n "git.loony"
    tmux send-keys "cd ${LOONY_WORKSPACE}" C-m

    tmux new-window -n "vim.loony"
    tmux send-keys "cd ${LOONY_WORKSPACE}" C-m

    tmux new-window -n "git.vos.gha"
    tmux send-keys "cd ${VOSSLOH_GH_ACTIONS}" C-m

    tmux new-window -n "vim.vos.gha"
    tmux send-keys "cd ${VOSSLOH_GH_ACTIONS}" C-m
}

VAD_WORKSPACE="/home/nicolas/work/siema/be/VAD/src/vad-zephyr"
VAD_SN="vad"
tmux_vad()
{
    SESSION_NAME="${VAD_SN}"

    tmux attach-session -d -t ${SESSION_NAME}
    ret="$?"
    if [[ "${ret}" == 0 ]]; then
        return
    fi
    tmux new-session -d -s ${SESSION_NAME}
    tmux rename-window "west"
    tmux send-keys "cd ${VAD_WORKSPACE}" C-m
    tmux send-keys "workon vad-lg" C-m

    tmux new-window -n "vim.vad"
    tmux send-keys "cd ${VAD_WORKSPACE}" C-m
    tmux send-keys "workon vad-lg" C-m

    tmux new-window -n "git.vad"
    tmux send-keys "cd ${VAD_WORKSPACE}/vad-zephyr-nodes" C-m
    tmux send-keys "workon vad-lg" C-m

    tmux new-window -n "docker.test"
    tmux send-keys "cd ${VAD_WORKSPACE}" C-m

    if [ "$(hostname)" == "firefly" ]; then
        tmux new-window -n "lg.exporter"
        tmux send-keys "cd ${VAD_WORKSPACE}" C-m
        tmux send-keys "ssh vosslohcicd@localhost" C-m
        tmux send-keys "cd ${VAD_WORKSPACE}" C-m
        tmux send-keys "workon vad-lg" C-m
        tmux send-keys "labgrid-exporter vad-zephyr-nodes/labgrid/firefly-exporter.yml --hostname vosslohcicd@firefly.railway.ad --crossbar ws://labgrid.railway.ad:20408/ws" C-m
    fi
}
# shellcheck disable=SC2139
alias _tmux_vad_bis="tmux new-session -s ${VAD_SN}-bis -t ${VAD_SN}"
