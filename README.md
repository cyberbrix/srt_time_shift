# srt_time_shift
shifts SRT times forward or backwards by seconds


Designed to be a portable Linux script, it uses standard shell commands, (and awk) to move srt file time codes.

Proper Usage: 
scriptname <sourcesrt> <+/-><seconds> 

Examples
srt_time_shift.sh /tmp/file.srt +5 
srt_time_shift.sh /tmp/file.srt -2.5

Note: There is no space between the plus/minus and the time difference.
