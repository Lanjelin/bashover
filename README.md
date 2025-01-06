# bashover
A simpler way to send pushover notifications using bash  
Every argument for [pushover](https://pushover.net/api) available directly from the terminal, supports configuration files.

## Examples
`./bashover.sh -t "token-goes-here" -u "user-key-here" -m "Hello World" --title "Bashover"`  

`./bashover.sh -t "token" -u "user" -m "Here is the latest screenshot" --title "Screenshot" --attachment ~/screenshot.png --priority "1" --sound "tugboat" -v`

`./bashover.sh -c ~/.conf/bashover/server.conf --attachment ~/temperatures.png -m "High temperature on drive 1" --title "Warning: high temp"`

## Config file
The script creates a defaul config.file at `~/.config/bashover/default.conf` where default values for all arguments can be stored.  
Parsed arguments takes precedence, and default values can be ignored by parsing `-i` or `--ignore-defaults`. 

This way token, user key and title can be stored as defaults, and a message can be sent by a simple command as `./bashover.sh -m "Hello World"`  

Additional config files can be used, and parsed using the `-c` or `--config` argument.  
`./bashover.sh -c ~/my-bashover-config.conf`

## Arguments
### Bashover arguments
 - `-i` or `--ignore-defaults` - ignore the default config file
 - `-v` - outputs the returned response from pushover
 - `-c` or `--config` - parse a custom config file
### Pushover defaults
 - `-t` or `--token` - your application's API token (required)
 - `-u` or `--user` - your user/group key (required)
 - `-m` or `--message` - your message (required)
 - `--attachment` -  a binary image attachment to send with the message ([documentation](https://pushover.net/api#attachments))
 - `--attachment-base64` - a Base64-encoded image attachment to send with the message ([documentation](https://pushover.net/api#attachments))
 - `--attachment-type` - the MIME type of the included `attachment` or `attachment_base64` ([documentation](https://pushover.net/api#attachments))
 - `--device` - the name of one of your devices to send just to that device instead of all devices ([documentation](https://pushover.net/api#identifiers))
 - `--html` - set to 1 to enable HTML parsing ([documentation](https://pushover.net/api#html))
 - `--priority` - a value of -2, -1, 0 (default), 1, or 2 ([documentation](https://pushover.net/api#priority))
 - `--sound` - the name of a supported sound to override your default sound choice ([documentation](https://pushover.net/api#sounds))
 - `--timestamp` - a Unix timestamp of a time to display instead of when our API received it ([documentation](https://pushover.net/api#timestamp))
 - `--title` - your message's title, otherwise your app's name is used 
 - `--ttl` - a number of seconds that the message will live, before being deleted automatically ([documentation](https://pushover.net/api#ttl))
 - `--url` - a supplementary URL to show with your message ([documentation](https://pushover.net/api#urls))
 - `--url-title` - a title for the URL specified as the `url` parameter, otherwise just the URL is shown ([documentation](https://pushover.net/api#urls))
 - '--retry' - specifies how often (in seconds) the Pushover servers will send the same notification to the user ([documentation](https://pushover.net/api#priority2))
 - '--expire' - specifies how many seconds your notification will continue to be retried for (every retry seconds) ([documentation](https://pushover.net/api#priority2))
