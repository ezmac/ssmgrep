#!/bin/bash
IFS=$'\n'       # make newlines the only separator


OPTS=`getopt -o r: --long recursive -n 'parse-options' -- "$@"`


# really I need to clean up opt parsing
while true; do
  case "$1" in
    -r | --recursive) 
             recursive=true; shift;;
    * ) break ;;            
  esac
  
done
term="$1"
if [[ ! -z $2 ]]; then
  path="$2"
fi


if [[ -z AWS_PROFILE ]]; then
  AWS_PROFILE=personal
fi

# So, basically, ssmgrep 'close enough expression to grep' [-i /path/]

# step 1, describe parameters
  #may be relagated later to an if condition
if [[ ! -z $path ]]; then
  parameters=$(aws ssm get-parameters-by-path --recursive --path $path --query 'Parameters[].[Name,Value]' --with-decryption --output text)

  for param in $parameters; do 
    param_content=$(echo "$param"|cut -f2 -d\ )
    grep_results=$(echo "$param_content" | grep --color=always $term 1>/dev/null)
    if [[ 0 == $? ]]; then 
      echo $(echo \"$param\"|cut -f1 -d\ ) $grep_results
    fi
    # https://askubuntu.com/questions/797129/command-output-redirection-using 
    # command output redirection lets us use the content of a variable as a file argument to a command
  done
else
  parameters=$(aws ssm describe-parameters --query 'Parameters[].[Name]' --output text)
  # https://stackoverflow.com/questions/55714619/pass-file-contents-as-password-parameter-in-bash-script
  for param in $parameters; do 
    param_content=$(aws ssm get-parameter --name $param --with-decryption --query 'Parameter.Value' --output text )
    grep_results=$(echo "$param_content" | grep --color=always $term )
    if [[ 0 == $? ]]; then 
      echo "$param $grep_results"
    fi
    # https://askubuntu.com/questions/797129/command-output-redirection-using 
    # command output redirection lets us use the content of a variable as a file argument to a command
  done
fi








