# !/bin/sh
GITIGNORE_FILE="$HOME/.gitignore"
truncate -s 0 $GITIGNORE_FILE

# If you prefer using one-line command try:
# curl -sL "https://github.com/github/gitignore/raw/main/Global/{Linux,macOS,Windows}.gitignore" >> $GITIGNORE_FILE

# For each element in the array, the following will:
# - prefix with the source url commented out
# - download the gitignore file
# - remove comment lines
# - remove blank lines
# - sort lines
# - append a blank line at the end
# - append result of all above operations to local gitignore file

global_gitignores=( Linux macOS Windows )
for i in "${global_gitignores[@]}"; do
    GITIGNORE_URL="https://github.com/github/gitignore/raw/main/Global/$i.gitignore"
    wget -q -l1 -O - $GITIGNORE_URL | sed -e 's:#.*$::g' -e '/^[[:blank:]]*$/ d' | sort | cat <(echo "# $GITIGNORE_URL") - <(echo "") >> $GITIGNORE_FILE
done
