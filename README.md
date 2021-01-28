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
  <h2 style="border-bottom: none !important;">
    🐧 Super-simple small bash (shell) script with zero dependencies,
    which manages notes with ease and grace of a terminal.
  </h2>
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

Create a dated text file at a specific location and append text to it. It's that simple!

Works literally on every Linux-like system. And probably should work on MacOS.
If not, please open an issue.

## 🤟 Getting Started

### 1. Download the script

Using curl:

```bash
curl -L https://raw.githubusercontent.com/novusnota/notes.sh/master/notes.sh
```

Or grab it from the latest [Release](https://github.com/novusnota/notes.sh/releases/latest)

### 2. Installing

There are at least two ways:

1. Just place it somewhere and add an alias

Example:

```bash
alias note='path/to/somethere/with/notes.sh'
```

2. Place it in your PATH with the name 'note'

Examples:

```
# If you have a ~/.local/bin on your PATH
mv notes.sh ~/.local/bin/note

# Preferred way, would work on pretty much every Linux
sudo mv notes.sh /usr/local/sbin/note

# MacOS way:
## don't know much, but the principle is the same:
## get to know your PATH and place the notes.sh somewhere in that folders
## to print out PATH:
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
    the end. bye-bye!
# note (xD), that tabs are not required.
```

Either way command produces a file called DD.md (with the current month day name)
to the $NOTES\_DIRECTORY/YYYY/MM. If the file exists, notes.sh will append to it.

## 🍀 Acknowledgements

Based on: https://github.com/nickjj/notes

## 📝 LICENSE

GNU General Public License v3.0 only.

