#!/usr/bin/env bash

usage() {
  echo "Usage: $(basename "$0") ACTION ARGS"
}

_set_display() {
  echo "$1" | sudo tee /sys/class/graphics/fb0/blank > /dev/null
}

keyboard_on() {
  sudo service fbkeyboard restart
}

keyboard_off() {
  sudo service fbkeyboard stop
}

display_on() {
  _set_display 0
  keyboard_on
}

display_off() {
  _set_display 1
  keyboard_off
}

display_is_on() {
  # FIXME
  grep -q 0 /sys/class/graphics/fb0/state
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  case "$1" in
    help|h|-h|--help)
      usage
      exit 0
      ;;
    display|dsp|d)
      case "$2" in
        on|enable)
          display_on
          ;;
        off|disable)
          display_off
          ;;
        *)
          if display_is_on
          then
            echo on
          else
            echo off
          fi
          ;;
      esac
      ;;
    keyboard|kb)
      case "$2" in
        on|enable)
          keyboard_on
          ;;
        *)
          keyboard_off
          ;;
      esac
      ;;
    *)
      usage >&2
      exit 2
      ;;
  esac
fi
