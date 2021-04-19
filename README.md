<div align="center">
  <h1 style="border-bottom: none !important;">📝 notes.sh</h1>
  <p>
<pre>
                m                                #
m mm    mmm   mm#mm   mmm    mmm           mmm   # mm
#"  #  #" "#    #    #"  #  #   "         #   "  #"  #
#   #  #   #    #    #""""   """m          """m  #   #
#   #  "#m#"    "mm  "#mm"  "mmm"    #    "mmm"  #   #
</pre>
  </p>
  <a target="_blank" href="https://www.gnu.org/software/bash/">
    <img
      src="https://img.shields.io/badge/Made%20with-Bash-1f425f.svg"
      alt="Made with Bash 4: notes.sh, a super-simple small bash (shell) script with zero dependencies, which manages notes with ease and grace of a terminal" />
  </a>
  <a target="_blank" href="http://commonmark.org">
    <img
      src="https://img.shields.io/badge/Made%20with-Markdown-1f425f.svg"
      alt="Made with MarkDown: notes.sh, a super-simple small bash (shell) script with zero dependencies, which manages notes with ease and grace of a terminal" />
  </a>
  <a href="https://github.com/novusnota/notes.sh#license">
    <img
      src="https://img.shields.io/badge/LICENSE-GPLv3.0-blue"
      alt="LICENSE for the notes.sh, a super-simple small bash (shell) script with zero dependencies, which manages notes with ease and grace of a terminal" />
  </a>

</div>

## 🐧 About

Super-simple small bash (shell) script with zero dependencies,
which manages notes with ease and grace of a terminal.

Create a dated text file at a specific location and append text to it. It's that simple!

Works literally on every Linux-like system. And probably should work on MacOS.
If not, please open an [issue](https://github.com/novusnota/notes.sh/issues).

###### NOTE (unintended pun):

Some features, such as: custom note creation template
or dynamic folder resolution rely on git installed
and on a .git folder inside of this repo.

## 🤟 Getting Started

#### 1. Download the script

Using curl:

```bash
curl -L https://raw.githubusercontent.com/novusnota/notes.sh/master/notes.sh
```

Or grab it from the latest [Release](https://github.com/novusnota/notes.sh/releases/latest)

#### 2. Installing

There are at least two ways:

1. Just place it somewhere and add an alias

Example:

```bash
alias note='path/to/somewhere/with/notes.sh'
```

2. Create a symbolic link somewhere on your PATH.

Examples:

```
# If you have a ~/.local/bin on your PATH
ln -s /path/to/somewhere/with/notes.sh ~/.local/bin/note

# Preferred way, would work on pretty much every Linux
sudo ln -s /path/to/somewhere/with/notes.sh /usr/local/sbin/note

# MacOS way:
## don't know much, but the principle is the same:
## get to know your PATH and create a link to notes.sh
## somewhere in that folders
##
## To print out PATH use:
echo $PATH | tr : '\n'
```

## 🧐 Usage

Append that text to the today's file:

```bash
note something you want to write down
```

Append your clipboard to the file:

```bash
# If you use xsel
xsel -bo | note

# If you use xclip
xclip -o | note

# If you use pbpaste (MacOS)
pbpaste | note
```

Open the file in your editor:

```bash
note
```

Append rather big text to the file:

```bash
# using cat <<EOF trick,
# don't forget to add
# EOF
# on the last line to stop
cat <<EOF | note

# or using backslash escapes - \
note \
    blah blah \
    more blah blah \
    the end. bye-bye\!
# note (xD), that tabs are not required.
# also keep in mind, that Bash handles args before they get into the script
# and some characters like !@`#\ should be escaped, and some '" should match their pairs.
#
# to escape a character, append a backwards slash before it like so:
# \!
```

Either way command creates a file called DD.md
in the $C\_NOTES\_DIR/YYYY/MM. If the file exists, notes.sh will append to it.

Destination folder, filename and other things can be changed using a configuration file, see Customization below.

## 🔧 Customization

Set the variables of config.sh to your liking.

For your ease of use, there is already an config.example.sh —
just rename it to config.sh and you're good to go!

#### Variables

- C\_NOTES\_DIR (/path/to/notes/directory) — Top-level directory for all the notes

- C\_NOTES\_EDITOR (nvim, nano, sublime, whatever) — Use an editor to change today's note file manually

- C\_NOTES\_DELIMITER (\n---\n, for example) Delimiter between the separated notes inside today's note file

- C\_NOTES\_Y\_SUBDIR (true/false) — Create a %Year% subfolder for the notes?

- C\_NOTES\_M\_SUBDIR (true/false) — Create a %Month% subfolder for the notes?

- C\_NOTES\_FORMAT (txt, md, whatever) — File extension (what goes after the . (dot) in the filenames)

- C\_NOTES\_TEMPLATE (/path/to/file) — A template for the new notes

## 🍀 Acknowledgements

Based on: https://github.com/nickjj/notes

## 📝 LICENSE

GNU General Public License v3.0 only.

