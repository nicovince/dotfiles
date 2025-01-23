#!/bin/bash
# Tmux Minecraft sessions

MC_WORKSPACE="/home/nicolas/Games/MinecraftServer"
RC4_WORKSPACE="${MC_WORKSPACE}/RC4"
tmux_rc4()
{
    SESSION_NAME="mc-rc4"
    tmux attach-session -d -t ${SESSION_NAME}
    ret="$?"
    if [[ "${ret}" == 0 ]]; then
        return
    fi
    tmux new-session -d -s ${SESSION_NAME}

    tmux rename-window "mc-rc4"
    tmux send-keys "cd ${RC4_WORKSPACE}" C-m
    tmux send-keys "./start.sh" C-m

    tmux attach-session -t ${SESSION_NAME}
}

JUCO_WORKSPACE="${MC_WORKSPACE}/juco"
tmux_juco()
{
    SESSION_NAME="mc-juco"
    tmux attach-session -d -t ${SESSION_NAME}
    ret="$?"
    if [[ "${ret}" == 0 ]]; then
        return
    fi
    tmux new-session -d -s ${SESSION_NAME}

    tmux rename-window "mc-rc4"
    tmux send-keys "cd ${JUCO_WORKSPACE}" C-m
    tmux send-keys "./start.sh" C-m

    tmux attach-session -t ${SESSION_NAME}
}
