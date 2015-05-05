# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to disable command auto-correction.
# DISABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git github gpg-agent ssh-agent archlinux pass)

source $ZSH/oh-my-zsh.sh

# User configuration
source ~/.profile
source ~/.keys

autoload -U compinit
compinit
unsetopt correct_all
unsetopt share_history

streaming() {
	INRES="1920x1080" # input resolution
	OUTRES="1920x1080"
	FPS="25" # target FPS
	GOP="50" # i-frame interval, should be double FPS
	GOPMIN="25" # min i-frame interval, should be equal to FPS
	THREADS="2"
	CBR="750k"
	QUALITY="fast" #x264 preset: ultrafast,superfast,veryfast,faster,fast,medium
	AUDIO_RATE="44100"
	SERVER="live-jfk"

	ffmpeg  -thread_queue_size 512 -f x11grab -s "$INRES" -r "$FPS" -i :1.0 \
		-thread_queue_size 512 -f alsa -i pulse -ac 2 -ar $AUDIO_RATE \
		-vcodec libx264 -g $GOP -keyint_min $GOPMIN -b:v $CBR -minrate $CBR -maxrate $CBR -bufsize $CBR \
			-preset $QUALITY -s "$OUTRES" -pix_fmt yuv420p -tune film \
		-acodec libmp3lame -ar 44100 -ab 64k -threads $THREADS -strict normal \
		-f flv "rtmp://$SERVER.twitch.tv/app/$TWITCH_STREAM_KEY"
}

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"
