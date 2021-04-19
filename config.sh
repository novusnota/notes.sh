#!/bin/bash

# (IMPORTANT) Top-level directory for all the notes
export C_NOTES_DIR="${HOME}/Notes"

# (IMPORTANT) Use an editor to change today's note file manually
export C_NOTES_EDITOR="vi"

# (optional) Delimiter between the separated notes inside today's note file
export C_NOTES_DELIMITER="\n---\n"

# (optional) Create a %Year% subfolder for the notes?
export C_NOTES_Y_SUBDIR="true"

# (optional) Create a %Month% subfolder for the notes?
export C_NOTES_M_SUBDIR="true"

# (optional) File extension (what goes after the . in the filenames)
export C_NOTES_FORMAT="md"

# (optional) A /path/to/template file for the new notes
export C_NOTES_TEMPLATE="template"

# (CHANGE ONLY IF YOU KNOW, WHAT YOU'RE DOING) Export args, if any
test "${#}" -ne 0 && export "${@}"

