#!/usr/bin/env bash

readonly config="$HOME/.config/bashover/default.conf"
readonly pushover_url="https://api.pushover.net/1/messages.json"
readonly valid_args=$(getopt -o t:u:m:ivc: --long token:,user:,message:,attachment:,attachment-base64:,attachment-type:,device:,html:,priority:,sound:,timestamp:,title:,ttl:,url:,url-title:,ignore-defaults,config: -- "$@")

make_config () {
  echo token='""' >> "$1"
  echo user='""' >> "$1"
  echo message='""' >> "$1"
  echo attachment='""' >> "$1"
  echo attachment_base64='""' >> "$1"
  echo attachment_type='""' >> "$1"
  echo device='""' >> "$1"
  echo html='""' >> "$1"
  echo priority='""' >> "$1"
  echo sound='""' >> "$1"
  echo timestamp='""' >> "$1"
  echo title='""' >> "$1"
  echo ttl='""' >> "$1"
  echo url='""' >> "$1"
  echo url_title='""' >> "$1"
}

parse_config () {
  source $1
  a_token="${a_token:-${token}}"
  a_user="${a_user:-${user}}"
  a_message="${a_message:-${message}}"
  a_attachment="${a_attachment:-${attachment}}"
  a_attachment_base64="${a_attachment_base64:-${attachment_base64}}"
  a_attachment_type="${a_attachment_type:-${attachment_type}}"
  a_device="${a_device:-${device}}"
  a_html="${a_html:-${html}}"
  a_priority="${a_priority:-${priority}}"
  a_sound="${a_sound:-${sound}}"
  a_timestamp="${a_timestamp:-${timestamp}}"
  a_title="${a_title:-${title}}"
  a_ttl="${a_ttl:-${ttl}}"
  a_url="${a_url:-${url}}"
  a_url_title="${a_url_title:-${url_title}}"
}

parse_arguments() {
  eval set -- "$valid_args"
  while [ : ]; do
    case "$1" in
      -t | --token)
        a_token="$2"
        shift 2
        ;;
      -u | --user)
        a_user="$2"
        shift 2
        ;;
      -m | --message)
        a_message="$2"
        shift 2
        ;;
      --attachment)
        a_attachment="$2"
        shift 2
        ;;
      --attachment-base64)
        a_attachment_base64="$2"
        shift 2
        ;;
      --attachment-type)
        a_attachment_type="$2"
        shift 2
        ;;
      --device)
        a_device="$2"
        shift 2
        ;;
      --html)
        a_html="$2"
        shift 2
        ;;
      --priority)
        a_priority="$2"
        shift 2
        ;;
      --sound)
        a_sound="$2"
        shift 2
        ;;
      --timestamp)
        a_timestamp="$2"
        shift 2
        ;;
      --title)
        a_title="$2"
        shift 2
        ;;
      --ttl)
        a_ttl="$2"
        shift 2
        ;;
      --url)
        a_url="$2"
        shift 2
        ;;
      --url-title)
        a_url_title="$2"
        shift 2
        ;;
      -i | --ignore-defaults)
        a_ignore_defaults=True
        shift
        ;;
      -v)
        a_verbose=True
        shift
        ;;
      -c | --config)
        a_config="$2"
        shift 2
        ;;
      --) shift;
        break
        ;;
    esac
  done
}

main() {
  if [ ! -f "$config" ]; then
    echo "No default config found, creating at $config"
    mkdir -p $HOME/.config/bashover
    make_config $config
  fi

  parse_arguments $@

  if [[ -n $a_config ]]; then
    if [ ! -f "$a_config" ]; then
      echo "Error: Config not found at $a_config, making a template."
      make_config $a_config
      exit 1;
    fi
    parse_config $a_config
  fi

  if [[ ! $a_ignore_defaults && -z $a_config ]]; then
    parse_config $config
  fi

  if [ ${#a_token} == 0 ]; then
    echo "Error: You need to supply an app token"
    exit 1;
  fi

  if [ ${#a_user} == 0 ]; then
    echo "Error: You need to supply a user key"
    exit 1;
  fi

  if [ ${#a_message} == 0 ]; then
    echo "Error: Message cannot be blank"
    exit 1;
  fi

  response=`curl -s \
    --form-string "token=$a_token" \
    --form-string "user=$a_user" \
    --form-string "message=$a_message" \
    ${a_attachment:+--form "attachment=@$a_attachment"} \
    ${a_attachment_base64:+--form-string "attachment_base64=$a_attachment_base64"} \
    ${a_attachment_type:+--form-string "attachment_type=$a_attachment_type"} \
    ${a_device:+--form-string "device=$a_device"} \
    ${a_html:+--form-string "html=$a_html"} \
    ${a_priorit:y+--form-string "priority=$a_priority"} \
    ${a_sound:+--form-string "sound=$a_sound"} \
    ${a_timestamp:+--form-string "timestamp=$a_timestamp"} \
    ${a_title:+--form-string "title=$a_title"} \
    ${a_ttl:+--form-string "ttl=$a_ttl"} \
    ${a_url:+--form-string "url=$a_url"} \
    ${a_url_title:+--form-string "url_title=$a_url_title"} \
    $pushover_url`

  if [ $a_verbose ]; then
    echo $response
  fi

  exit 0;
}

main $@
