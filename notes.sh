#!/bin/bash
#
#                    m                                #
#    m mm    mmm   mm#mm   mmm    mmm           mmm   # mm
#    #"  #  #" "#    #    #"  #  #   "         #   "  #"  #
#    #   #  #   #    #    #""""   """m          """m  #   #
#    #   #  "#m#"    "mm  "#mm"  "mmm"    #    "mmm"  #   #
#
#         See: https://github.com/novusnota/notes.sh
#                     Version: 1.0.1
#
# Create a dated text file at a specific location and append text to it.
#
# Installing:
#   1. Just place it somewhere and add an alias:
#
#        alias note='path/to/somethere/with/notes.sh'
#
#   2. Place it somewhere in your path with the name 'note':
#
#        mv notes.sh ~/.local/bin/note
#      or
#        sudo mv notes.sh /usr/local/sbin/note
#
# Usage:
#   $ note something you want to write down (appends that text to the file)
#   $ xsel -bo | note                       (appends your clipboard to the file)
#   $ note                                  (opens the file in your editor)
#
# Produces:
#   DD.md in your $NOTES_DIRECTORY/YYYY/MM (this is set below).
#
# -------------------------------------------------------------
#
# mmmmmmmmm Feel free to edit anything tagged 'EDIT:' mmmmmmmmm
#

# TODO: Somehow shield (\) ', ", (), [], `, !, and other stuff.
# Bash does that even before the args are passed into the script, so idk.

##
# Stopping at the first error
##
set -e

##
# Getting date and time
##
readonly NOTES_DATE=($(date '+%Y %m %d'))
readonly NOTES_Y="${NOTES_DATE[0]}"
readonly NOTES_M="${NOTES_DATE[1]}"
readonly NOTES_D="${NOTES_DATE[2]}"

##
# EDIT: Change this to your favourite text file format
##
readonly NOTES_FORMAT='md'

##
# EDIT: Remove this section, if you've already set EDITOR, or don't want to use (Neo)Vim.
#              vvvv
##
vimDerivative='nvim'

if [ -z "$(which nvim)" ]; then
    if [ -z "$(which vim)" ]; then
        vimDerivative='vi'
    else
        vimDerivative='vim'
    fi
fi

readonly NOTES_EDITOR="${EDITOR:-"$vimDerivative"}"
##
#              ^^^^
# EDIT: Remove this section, if you've already set EDITOR, or don't want to use (Neo)Vim.
##

##
# EDIT: Change the NOTES_CUSTOM_DIRECTORY to your liking
# To check the contents of the HOME variable:
# echo $HOME
##
readonly NOTES_CUSTOM_DIRECTORY="${HOME}/LECS/notes/${NOTES_Y}/${NOTES_M}"
readonly NOTES_DIRECTORY="${NOTES_DIRECTORY:-"$NOTES_CUSTOM_DIRECTORY"}"

##
# Setting file and final path to it
##
readonly NOTES_FILE="${NOTES_D}.${NOTES_FORMAT}"
readonly NOTES_PATH="${NOTES_DIRECTORY}/${NOTES_FILE}"

##
# Checking if NOTES_DIRECTORY exists
##
if [ ! -d "${NOTES_DIRECTORY}" ]; then
    while :; do
        read -rp "${NOTES_DIRECTORY} does not exist, do you want to create it? (y/n) " yn
        case "${yn}" in
            [Yy]* ) mkdir -p "${NOTES_DIRECTORY}"; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer y or n";;
        esac
    done
fi

##
# Check if file is empty or consists only of space characters
# If so, clean up and remember not to add an '---' prefix before the note itself,
# because it would be a first note in the file
##
touch "${NOTES_PATH}"  # Update the time stamp and create a file, if it's missing.

prefix='\n---\n'
if [ $(cat "${NOTES_PATH}" | grep -c '\S') -lt 1 ]; then
    prefix=''
fi

##
# Debugging section
#           vvvvvvv
##
echoList() {
    local args=("$@")
    for arg in "${args[@]}"; do
        echo "$arg"
    done
}

logAndExit() {
    echoList \
        "Directory: $NOTES_DIRECTORY" \
        "File: $NOTES_FILE" \
        "Format: $NOTES_FORMAT" \
        "Path: $NOTES_PATH" \
        "Editor: $NOTES_EDITOR" \
       "Prefix: $prefix"
    exit 0
}

# Print out most of variables to visually
# check their values and exit before
# trying to write a note somewhere
# (not an autotest, I know :)
#logAndExit

##
#           ^^^^^^^
# Debugging section
##

##
# Try to get arguments from stdin and append them OR launch an editor directly
# Otherwise, append current arguments to the file
##
if [ ${#} -eq 0 ]; then
    if [ -p "/dev/stdin" ]; then
        (echo -en "${prefix}\n"; cat; echo -en "\n") >> "${NOTES_PATH}"
    else
        eval "${NOTES_EDITOR}" "${NOTES_PATH}"
    fi
else
    echo -en "${prefix}\n${*}\n" >> "${NOTES_PATH}"
fi

##
# P.S.: Please, give me a star, if you like it.
# Proceed to: https://github.com/novusnota/notes.sh
##

# TODO: Be aware, that )('"!` are not escaped by default just because bash
# handles args before they get into the script. Possible fix: ncurses.
# TODO: Auto-find links (by regex) and change them
# from <space>link<space> to <space>[](link)<space>
