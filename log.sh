#!/bin/bash

export LOG_INFO="info"
export LOG_WARN="warn"
export LOG_ERR="error"

# Public: Prints a log to the console.
#
# This prints a log to the console with a specified log level and message.
# Log messages "caller_name: time [LEVEL] message". Here, "caller_name" is
# the name of the script executing this function.
#
# $1 - the log level, converted to uppercase. This cannot be empty.
# $2 - the log message. This cannot be empty.
# $3 - program name spacing. This is parameter is optional, and defaults to
#      a value of zero. This applies padding to the left of the program name,
#      and is useful when multiple programs will make use of this function,
#      as it aligns the formatting.
#
# Examples
#
#   log LOG_INFO "Bash is awesome!"
#   
#   log LOG_INFO "You will never use Batch", 10     # from sonic.sh
#   log LOG_INFO "Do I look like I need Batch?", 10 # from knuckles.sh
#
# Returns 0 upon successful execution. Returns 1 if less than two arguments
#   are provided, the log level is empty, or the log message is empty.
function log() {
    if [[ $# -lt 2 ]]
	then
	  printf "log(): expecting log level and message.\n"
	  return 1 # not enough arguments
	fi

    program_name="$0"                  # script calling this method
	program_name="${program_name#./*}" # strip away header
	program_name="${program_name%*.}"  # strip away file extension
	
	log_level="${1^^}"                 # first argument, in uppercase
	log_message="$2"                   # second argument, left as-is
	
	# Neither the log level or the log message can be empty strings.
	# It would not make sense to do this! As such, assume this was a
	# mistake by the user and return with an error message.
	if [[ ${#log_level} -lt 1 ]]
	then
	  printf "log(): log level cannot be empty.\n"
	  return 1 # empty log level
	elif [[ ${#log_message} -lt 1 ]]
	then
	  printf "log(): log message cannot be empty.\n"
	  return 1 # empty log message
	fi
	
	# By default, there is no padding used when printing out a log message.
	# However, if a third argument is specified by the caller, use it for
	# the program name padding instead.
	program_name_pad=0                 # default to no padding
	if [[ $# -ge 3 ]]
	then
	  program_name_pad="$3"            # use padding specified by caller
	fi
	
	# The code below uses AWK to get extract the fourth column of the "date"
	# command, which contains the hour, minute, and second. This helps users
	# keep track of the time it takes for the program to run.
	time_str=$(date | awk '{print $4}')

    # The code below prints out the formatted message, with the padding for
	# the program name as described earlier on in the script. It looks ugly
	# here so the logger can look pretty in the console.
	printf "%-${program_name_pad}s %s [%s] %s\n" "$program_name:" \
	       "$time_str" "$log_level" "$log_message"
	return 0
}
