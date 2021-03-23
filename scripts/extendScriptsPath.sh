#!/usr/bin/env bash

script_path=$(pwd)/scripts

profile_file=~/.profile

if grep -q $script_path $profile_file
  then
    echo "SKIPPED. $script_path already in $profile_file"
  else
    echo $'\n'PATH=\$PATH:"$script_path" >> $profile_file
    # update the current profile to apply changes into the current bash session
    . ~/.profile
fi

echo "To apply the profile changes in another bash session without restart, run: "
echo ". ~/.profile"