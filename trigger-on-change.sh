#!/bin/bash

# Usage message function
usage() {
  echo "Usage: $0 [OPTIONS]"
  echo "Watch a directory for file changes and run a callback on matching files."
  echo ""
  echo "OPTIONS:"
  echo "  -p <pattern>   File pattern to match (default: .txt)"
  echo "  -c <command>   Command to run when a matching file is modified (callback)."
  echo "  -d <dir>       Directory to watch (default: current directory)."
  echo "  -a             Append the modified file path as an argument to the callback."
  echo "  -h             Show this help message and exit."
  echo ""
  echo "Example 1: $0 -p '.log' -c './process_file.sh' -d '/path/to/watch'"
  echo "Example 2: $0 -p '.txt' -c 'echo \${File modified}: ' -a"
  exit 0
}

# FUNCTION PARAMETERS
file_pattern=".txt"
callback=""
watch_directory="./"
is_append_callback=false

# Parse command line arguments with flags
while getopts "h:p:c:d:a" OPTION; do
  case "$OPTION" in
  p)
    file_pattern="$OPTARG"
    ;;
  c)
    callback="$OPTARG"
    ;;
  d)
    watch_directory="$OPTARG"
    ;;
  a)
    is_append_callback=true
    ;;
  h)
    usage
    exit 0⇧
    ;;
  *)
    usage
    exit 0
    # exit 1 # it's also kill terminal
    ;;
  esac
done

# Execute a command upon an event
cleanup() {
  printf "\nHot reload finished.\n"
  exit 0
}
trap cleanup SIGINT

# DETECT CHANGES AND RUN CALLBACK
echo "Watching all ${file_pattern} files in ${watch_directory}."
if [ -z "$callback" ]; then
  echo "Running {printf '\n\n\$path\$file'} every time a trigger is activated."
else
  if [ "$is_append_callback" = true ]; then
    echo "Running '{$callback} \$path\$file\' on the modified file path."
  else
    echo "Running ${callback}."
  fi
fi

inotifywait \
  --include ".*\\${file_pattern}$" \
  -m -r -e modify $watch_directory | while read path action file; do

  # The -z operator in a shell script is used to check if a string is empty.
  if [ -z "$callback" ]; then
    printf '\n\n'$path$file' modified.'
  else
    if [ "$is_append_callback" = true ]; then
      # Ensure callback is executed with the correct parameters
      eval "$callback\"$path$file\""
    else
      # Use eval to run the callback as a command
      eval "$callback"
    fi
  fi
done
