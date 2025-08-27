#!/bin/bash
# 
# make-screenshots.sh
# 
# Create screenshots using website-screenshot[1].
# 
# [1]: https://github.com/malte70/scripts/blob/master/website-screenshot
# 


##########################################
# Webdesigns
# 
WEBDESIGNS=(
	"eckig"
	"maltes-blog"
	"maltes-blog2"
	"orange"
	"template4"
)


SCRIPT_NAME="make-screenshots.sh"

_ANSI_ESCAPE=$(printf "\e")
_ANSI_RESET="${_ANSI_ESCAPE}[0m"
_ANSI_ATTR_ITALIC="${_ANSI_ESCAPE}[3m"
_ANSI_COLOR_YELLOW="${_ANSI_ESCAPE}[0;33m"
_ANSI_COLOR_LIGHT_RED="${_ANSI_ESCAPE}[1;31m"
_ANSI_COLOR_LIGHT_GREEN="${_ANSI_ESCAPE}[1;32m"
_ANSI_COLOR_CYAN="${_ANSI_ESCAPE}[1;36m"
_ANSI_COLOR_WHITE="${_ANSI_ESCAPE}[1;37m"
msg(){
    if [[ $1 == "--error" ]]
    then
        shift
        #echo " [${SCRIPT_NAME}]  Error: $@" >&2
        echo -n " ${_ANSI_COLOR_CYAN}[${_ANSI_COLOR_LIGHT_GREEN}${SCRIPT_NAME}${_ANSI_COLOR_CYAN}]${_ANSI_RESET}  ${_ANSI_COLOR_LIGHT_RED}ERROR:  " >&2
        echo    "${_ANSI_COLOR_WHITE}$@${_ANSI_RESET}" >&2
        
    else
        #echo " [${SCRIPT_NAME}]  $@"
        echo -n " ${_ANSI_COLOR_CYAN}[${_ANSI_COLOR_LIGHT_GREEN}${SCRIPT_NAME}${_ANSI_COLOR_CYAN}]${_ANSI_RESET}  "
        echo    "${_ANSI_COLOR_WHITE}$@${_ANSI_RESET}" >&2
        
    fi
}


##########################################
# website-screenshot from by scripts
# repo is required.
# 
if ! which website-screenshot &>/dev/null
then
    msg --error 'website-screenshot not found in $PATH!'
    msg --error 'It is part of https://github.com/malte70/scripts'
    exit 2
fi


##########################################
# Start a local webserver
# (website-screenshot only works remotely)
# 
msg 'Starting local webserver...'
python -u -m http.server --bind 127.0.0.1 18042 </dev/null &>/dev/null &

# https://stackoverflow.com/a/22644006/611293
trap "exit" INT TERM
trap "kill 0" EXIT


##########################################
# Create the screenshots
# 
msg 'Creating screenshots. This might take a while!'
for design in ${WEBDESIGNS[@]}
do
    msg "Creating screenshot for ${_ANSI_COLOR_YELLOW}$design${_ANSI_COLOR_WHITE}..."
    website-screenshot "http://127.0.0.1:18042/${design}/" "img/${design}.png"
    
done


##########################################
# Create scaled down (30%) screenshots
# 
msg 'Scaling down screenshots.'
for design in ${WEBDESIGNS[@]}
do
    msg "... ${_ANSI_COLOR_YELLOW}${design}${_ANSI_COLOR_WHITE}"
    convert "img/${design}.png" -resize 30% "img/${design}-small.png"
    
done


##########################################
# Clean up (remove geckodriver.log)
# 
msg 'Cleaning up...'
rm -f "geckodriver.log"

