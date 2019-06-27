# ssmgrep

A quick and currently dirty wrapper for using grep on ssm parameter values.

Current "bugs/features":

 - implicit --with-decryption for all parameters
 - only implements -r and --recursive; poorly
 - only case sensitive currently
 - only works with envirionmental variables/instance roles for AWS credentials


## usage:
make sure you have access with awscli

`./sshgrep.sh 'some search string'` # search all ssm parameters.

`./sshgrep.sh 'some search string' /my/path` # search subset prefixed by path
