#!/usr/bin/env bash

curl -sL "https://github.com/github/gitignore/raw/main/{Node,Terraform,Dotnet}.gitignore" > .gitignore
echo "Place .gitignore at the root of the repository"

# For each element in the array:
# - download the file contents
# - remove comment lines
# - remove blank lines
# - sort lines
# - add a comment line with the source URL at the top
# - append a blank line at the end
# - append result of all above operations to .gitignore_global file

GLOBAL_GITIGNORE=".gitignore_global"
SOURCE_GITIGNORES=(macOS VisualStudioCode)
for i in "${SOURCE_GITIGNORES[@]}"; do
    GITIGNORE_URL="https://github.com/github/gitignore/raw/main/Global/$i.gitignore"
    wget -q -l1 -O - $GITIGNORE_URL | sed -e 's:#.*$::g' -e '/^[[:blank:]]*$/ d' | sort | cat <(echo "# $GITIGNORE_URL") - <(echo "") >> $GLOBAL_GITIGNORE
done

$GITIGNORE_URL="https://github.com/github/gitignore/raw/main/community/OpenSSL.gitignore"
wget -q -l1 -O - $GITIGNORE_URL | sed -e 's:#.*$::g' -e '/^[[:blank:]]*$/ d' | sort | cat <(echo "# $GITIGNORE_URL") - <(echo "") >> $GLOBAL_GITIGNORE

$GITIGNORE_URL="https://github.com/github/gitignore/raw/main/community/AWS/SAM.gitignore"
wget -q -l1 -O - $GITIGNORE_URL | sed -e 's:#.*$::g' -e '/^[[:blank:]]*$/ d' | sort | cat <(echo "# $GITIGNORE_URL") - <(echo "") >> $GLOBAL_GITIGNORE

echo "Rename .gitignore_global to .gitignore and place it in your user home directory"
