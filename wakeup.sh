#!/bin/bash
#
# Copyright (C) 2017, Dario Jimenez "darjwx" <darjwx@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Needed for crontab
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:
export USER=

# Set when the computer will automatically wakeup
# The first command reset the alarms, and the second set one.
# As it is now, the next alarm wil be set to wake up the computer on 168h.
# You can use if you want seconds or minutes. And even dates with the date command.
sh -c "echo 0 > /sys/class/rtc/rtc0/wakealarm" 
sh -c "echo `date '+%s' -d '+ 168 hours'` > /sys/class/rtc/rtc0/wakealarm"