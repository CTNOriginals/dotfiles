# Share one ssh-agent across all shells, no key pre-loading
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent > ~/.ssh/agent.env
fi
if [ -f ~/.ssh/agent.env ]; then
    . ~/.ssh/agent.env > /dev/null
fi
