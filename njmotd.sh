locale_LANG=$LANG
M_IFS=$IFS
LANG="C.UTF-8"

IFS=:	# placer IFS a 0 
clear
#Figlet package needed!
njf="$(figlet -f slant $HOSTNAME)" 

#random number between 120-220
i="$(( ( RANDOM % 100 ) + 120 ))"

	
fct::var_lines_color () {
	b=236
    bn=$((b++))
    isneg=0
    
	while read -r line ;  do  ### options -r obligatoire
		
		((t_lines++))  # cpt le nb de lignes utiliser par figlet
		
		len_line[$((${#len_line[@]}))]=${#line} 
		PADDING_div_by_2=$(printf '%-*s' "$(( ($COLUMNS - ${#line})/2 ))")
        PADDING_div_by_2b=$(printf '%-*s' "$(( $COLUMNS - ($COLUMNS + ${#line})/2 ))")
		
        
        (( b == 232 )) &&  isneg=1
        
        if (( isneg == 1 )) ; then
        bn=$((b++))
        
        else
        bn=$((b--))
        fi
        
        echo -e "\033[48;05;${bn};38;05;$((i++))m${PADDING_div_by_2}${line}${PADDING_div_by_2b}"
        
	
	done <<< $1 
}
	    
fct::var_lines_color "${njf}"


#MHZ_CUR=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq)
#MHZ_MAX=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq)
#CTEMP=$(cat /sys/class/thermal/thermal_zone0/temp)

if [ -r /etc/nj/njnupdate.log ]; then
	while IFS='' read -r line || [[ -n "$line" ]]; do
    	updnb=$( echo $line | grep -o "^[[:digit:]]\+" )
   		
	done < "/etc/nj/njnupdate.log"
[[ -z "$updnb" ]] && updnb=0
    
else 
	updnb=0
fi

lastlog=$(last -2 -R  $USER | head -2 | tail -1 | cut -c 20-)

PADDING=$(printf '%-*s' "$(($COLUMNS))")
echo -e "\033[48;05;233;38;05;15m${PADDING}"

Msg_Welcome="Welcome back $USER on $HOSTNAME"
PADDING=$(printf '%-*s' "$(($COLUMNS - ${#Msg_Welcome}))")
echo -e "\033[48;05;234;38;05;15m${Msg_Welcome}${PADDING}"

Msg_Lastlog="last login time [$lastlog]" 
PADDING=$(printf '%-*s' "$(($COLUMNS - ${#Msg_Lastlog}))")
echo -e "\033[48;05;235;38;05;7m${Msg_Lastlog}${PADDING}"

Msg_Update="Server is $(uptime -p)" 
PADDING=$(printf '%-*s' "$(($COLUMNS - ${#Msg_Update}))")
echo -e "\033[48;05;236;38;05;7m${Msg_Update}${PADDING}"

if [[ "$updnb" -gt 0 ]]; then
Msg_Update="${updnb} package updates available!" 
PADDING=$(printf '%-*s' "$(($COLUMNS - ${#Msg_Update}))")
echo -e "\033[48;05;236;38;05;11m${Msg_Update}${PADDING}"
fi
# on replace IFS a sa valeur par défaut:
IFS=$M_IFS
export LANG=$locale_LANG
