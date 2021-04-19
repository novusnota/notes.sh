#!/bin/bash
#
#                    m                                #
#    m mm    mmm   mm#mm   mmm    mmm           mmm   # mm
#    #"  #  #" "#    #    #"  #  #   "         #   "  #"  #
#    #   #  #   #    #    #""""   """m          """m  #   #
#    #   #  "#m#"    "mm  "#mm"  "mmm"    #    "mmm"  #   #
#
#         See: https://github.com/novusnota/notes.sh
#                     Version: 2.0.5
#
# Create a dated text file at a specific location and append text to it.
#
# NOTE (unintended pun):
#   Some features, such as: custom note creation template
#   or dynamic folder resolution rely on git installed
#   and on a .git folder inside of this repo.
#
# Ways of installation:
#   1. Just place it somewhere and add an alias:
#
#        alias note='path/to/somewhere/with/notes.sh'
#
#   2. Create a symbolic link somewhere on your PATH.
#      For example, let's use /usr/local/sbin/:
#
#        sudo ln -s /path/to/this/folder's/notes.sh /usr/local/sbin/note
#
# Usage examples:
#   $ note something you want to write down (appends that text to the file)
#   $ xsel -bo | note                       (appends your clipboard to the file)
#   $ note                                  (opens the file in your editor)
#
#   pb-paste, xclip, tmux-copy-paste or clip can easily be used instead of xsel.
#
# Produces:
#   DD.md inside $HOME/Notes/YYYY/MM
#
#   Destination folder can be changed using a configuration file, see Customization below.
#
# Customization:
#   Set the variables of config.sh to your liking.
#
#   C_NOTES_DIR (/path/to/notes/directory) — Top-level directory for all the notes
# 
#   C_NOTES_EDITOR (nvim, nano, sublime, whatever) — Use an editor to change today's note file manually
# 
#   C_NOTES_DELIMITER (\n---\n, for example) Delimiter between the separated notes inside today's note file
#
#   C_NOTES_Y_SUBDIR (true/false) — Create a %Year% subfolder for the notes?
# 
#   C_NOTES_M_SUBDIR (true/false) — Create a %Month% subfolder for the notes?
# 
#   C_NOTES_FORMAT (txt, md, whatever) — File extension (what goes after the . (dot) in the filenames)
# 
#   C_NOTES_TEMPLATE (/path/to/file) — A template for the new notes
# 
# The End. Easy — wins!

######
#########################
### BASIC PREPARATION ###
#########################
######

##
# Stopping at the first error
##

set -e

##
# Checking an incorrect bash version
##

if [ "${BASH_VERSINFO[0]}" -lt 4 ]; then
    echo "Your bash version is:  '${BASH_VERSION}', but this script needs at least 4th."
    echo "Please, consider updating"
    exit 1
fi

##
# Getting back into the repo, if possible
##

cd "$(dirname "$(realpath "$0")")"

if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = "true" ]; then
    cd "$(git rev-parse --show-toplevel)"
fi

######
######################
### MISC FUNCTIONS ###
######################
######

True=0
False=1

isFile() {
    local target="$1"

    if [ -f "${target}" ]; then
        return $True
    fi

    return $False
}

isNotFile() {
    local target="$1"

    if isFile "${target}"; then
        return $False
    fi

    return $True
}

isDir() {
    local target="$1"

    if [ -d "${target}" ]; then
        return $True
    fi

    return $False
}

isNotDir() {
    local target="$1"

    if isDir "${target}"; then
        return $False
    fi

    return $True
}

askBeforeCreatingDir() {
    local target="$1"

    if isDir "${target}"; then
        return $True
    fi

    while :; do
        read -rp "${target} does not exist, do you want to create it? (y/n) " yn
        case "${yn}" in
            [Yy]* ) mkdir -p "${target}"; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer y or n";;
        esac
    done
}

removeSuffix() {
    local string="$1"
    local suffix="$2"

    echo "${string%$suffix*}"
}

removePrefix() {
    local string="$1"
    local prefix="$2"

    echo "${string#*$prefix}"
}

getNotesSubEntity() {
    local ySubdir="$1"
    local mSubdir="$2"

    local yText="$3"
    local mText="$4"

    # Either '/' or '_'
    local divider="$5"
    local result=""

    if [ "${divider}" = "_" ]; then

        if [ "${mSubdir}" != "true" ]; then
            result="${mText}${divider}${result}"
        fi

        if [ "${ySubdir}" != "true" ]; then
            result="${yText}${divider}${result}"
        fi

        echo "$result"

        return 0
    fi

    if [ "${mSubdir}" = "true" ]; then
        result="${mText}${divider}${result}"
    fi

    if [ "${ySubdir}" = "true" ]; then
        result="${yText}${divider}${result}"
    fi

    # Worthless...
    # if [ ! -z "${result}" ]; then
    #     echo "${result}${divider}"
    #     return 0
    # fi

    echo "$result"
}

# separated function for the files (because they should decrease)

######
#####################
### CONFIGURATION ###
#####################
######

##
# Assigning configuration-dependent constants their default values
# DO NOT CHANGE IT HERE, THERE IS config.sh IN THE SAME FOLDER FOR THAT PURPOSE
##

# Top-level directory for all the notes
C_NOTES_DIR="${HOME}/Notes"

# Use a specific editor for the notes edit
C_NOTES_EDITOR=""

if [ -n "$(which nano)" ]; then
    C_NOTES_EDITOR="nano"
else
    C_NOTES_EDITOR="vi"
fi

# Delimiter between the separated notes inside today's note file
C_NOTES_DELIMITER="\n---\n"

# Create a %Year% subfolder for the notes?
C_NOTES_Y_SUBDIR="true"

# Create a %Year% subfolder for the notes?
C_NOTES_Y_SUBDIR="true"

# Create a %Month% subfolder for the notes?
C_NOTES_M_SUBDIR="true"

# File extension (what goes after the . in the filenames)
C_NOTES_FORMAT="md"

# A /path/to/template file for the new notes
C_NOTES_TEMPLATE="template"

##
# If configuration exists, use it
##

# (CHANGE ONLY IF YOU KNOW, WHAT YOU'RE DOING)
C_NOTES_CONFIG="config.sh"

if [ -f "${C_NOTES_CONFIG}" ]; then
    source "${C_NOTES_CONFIG}"
fi

######
############
### MAIN ###
############
######

##
# Fetching day number, month number and a year number
##

readonly C_NOTES_DATE=($(date '+%Y %m %d'))
readonly C_NOTES_Y="${C_NOTES_DATE[0]}"
readonly C_NOTES_M="${C_NOTES_DATE[1]}"
readonly C_NOTES_D="${C_NOTES_DATE[2]}"

##
# Setting file and final path to it
##

C_NOTES_T_PATH="$( \
    getNotesSubEntity \
    "${C_NOTES_Y_SUBDIR}" \
    "${C_NOTES_M_SUBDIR}" \
    "${C_NOTES_Y}" \
    "${C_NOTES_M}" \
    '/')"

C_NOTES_T_FILE="$( \
    getNotesSubEntity \
    "${C_NOTES_Y_SUBDIR}" \
    "${C_NOTES_M_SUBDIR}" \
    "${C_NOTES_Y}" \
    "${C_NOTES_M}" \
    '_')"

if [ "${C_NOTES_DIR: -1}" != "/" ]; then
    C_NOTES_T_PATH="/${C_NOTES_T_PATH}"
fi

readonly C_NOTES_PATH="${C_NOTES_DIR}${C_NOTES_T_PATH}"
readonly C_NOTES_FILE="${C_NOTES_T_FILE}${C_NOTES_D}.${C_NOTES_FORMAT}"

readonly C_NOTES_FILEPATH="${C_NOTES_PATH}${C_NOTES_FILE}"

##
# Checking if C_NOTES_DIR exists,
# and trying to create it if it's not
##

askBeforeCreatingDir "${C_NOTES_DIR}"

##
# Create all intermediate folders
##

if isNotDir "${C_NOTES_PATH}"; then
    mkdir -p "${C_NOTES_PATH}"
fi

##
# Checking if file is empty or consists only of space characters
# If so, clean up and remember not to add an '---' prefix before the note itself,
# because it would be a first note in the file
##

if isNotFile "${C_NOTES_FILEPATH}"; then

    if isFile "${C_NOTES_TEMPLATE}"; then

        # Use a template, if it exists
        cat "${C_NOTES_TEMPLATE}" > "${C_NOTES_FILEPATH}"

    else

        # Update the time stamp and create a file.
        touch "${C_NOTES_FILEPATH}"
     
        # Remove the delimiter, because the file is empty
        C_NOTES_DELIMITER=""

    fi
fi

##
# Trying to append current arguments to the file
# and exit!
##

if [ "${#}" -ne 0 ]; then
    echo -en "${C_NOTES_DELIMITER}\n${*}\n" >> "${C_NOTES_FILEPATH}"

    exit 0
fi

##
# Trying to get arguments from stdin and append them
# and exit!
##

if [ -p "/dev/stdin" ]; then
    (echo -en "${C_NOTES_DELIMITER}\n"; cat; echo -en "\n") >> "${C_NOTES_FILEPATH}"

    exit 0
fi

##
# Clear stdin, no args,
# just launching C_NOTES_EDITOR
##

eval "${C_NOTES_EDITOR}" "${C_NOTES_FILEPATH}"

##
# Exit!
##

exit 0

##
# P.S.: Please, give me a star, if you like it.
# Proceed to: https://github.com/novusnota/notes.sh
##

##
# Possible To-Do's
##

# Be aware, that )('"!` are not escaped by default just because bash
# handles args before they get into the script. Possible fix: ncurses.
#
# TODO: Somehow shield (\) ', ", (), [], `, !, and other stuff.

# TODO: Auto-find links (by regex) and change them
# from <space>link<space> to <space>[](link)<space>

