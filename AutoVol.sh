#!/bin/bash
####################
volatility_path="" #leave null if volatility is on /bin/ or /sbin/ etc
background_proc=0;
user_profile=""; # leave null if not known
plugins=""; # leave null if given by the CLI
memory_path="" #leave null if given by the CLI
Mac_profiles=(Yosemite ElCapitan Sierra HighSierra Leopard SnowLeopard Lion MountainLion Mavericks)
#################### Flags and paths
function help(){
    tput setaf 1;
    echo "Usage:"
    tput sgr 0;
    echo "  AutoVol.sh [Switches&Paths]"
    tput setaf 1;
    echo "Switches:"
    tput sgr 0;
    echo "  -h:help/this card"
    echo "  -f:specify memory file"
    echo "  --profile:specify user profile if known/given"
    echo "  --plugins:specify the plugin path"
    echo "  --info:Runs volatility's --info flag"
    echo "  -t to use background processes `(tput setaf 1)` NOTE: This flag makes the script very heavy and must not be used with old computers" `(tput setaf 7)`;
    tput setaf 1;
    echo -n "e.g: "
    tput setaf 7;
    echo "AutoVol.sh --plugins=./volatility/volatility/plugins -f memory.mem"
    echo "AutoVol.sh --plugins=./volatility/volatility/plugins -f memory.mem --profile=Win10x64"
    tput sgr 0;
}
function setFlags(){
    background_proc=`echo $@ |grep -e "-t" |wc -l`
    let "counter=${#@}-1"
    args=( "$@" )
    for i in `seq 0 $counter`
    do
        if [[ `echo ${args[$i]}| grep -e "^--profile"|wc -l` > 0 ]]
        then
            user_profile=`echo ${args[$i]} | sed 's/--profile=//g'`
        elif [[ `echo ${args[$i]}| grep -e "^--plugins"|wc -l` > 0 ]]
        then
            plugins=`echo ${args[$i]} | sed 's/--plugins=//g'`
        elif [[ `echo ${args[$i]} |grep -e "^-f$" |wc -l` > 0 ]]
        then
            memory_path=${args[$i+1]}
        fi;
    done
}
function runWindowsPlugins(){
    if [[ $background_proc == 0 ]]
    then
        $volatility_path -f $memory_path --profile=$user_profile pslist |tee $user_profile"_pslist.log"
        $volatility_path -f $memory_path --profile=$user_profile pstree |tee $user_profile"_pstree.log"
        $volatility_path -f $memory_path --profile=$user_profile psxview |tee $user_profile"_psxview.log"
        $volatility_path -f $memory_path --profile=$user_profile psscan |tee $user_profile"_psscan.log"
        $volatility_path -f $memory_path --profile=$user_profile cmdline |tee $user_profile"_cmdline.log"
        $volatility_path -f $memory_path --profile=$user_profile cmdscan |tee $user_profile"_cmdscan.log"
        $volatility_path -f $memory_path --profile=$user_profile consoles |tee $user_profile"_consoles"
        $volatility_path -f $memory_path --profile=$user_profile filescan |tee $user_profile"_filescan.log"
        $volatility_path -f $memory_path --profile=$user_profile mftparser |tee $user_profile"_mftparser.log"
        #$volatility_path -f $memory_path --profile=$user_profile dlllist |tee $user_profile"_dlllist.log"
        $volatility_path -f $memory_path --profile=$user_profile envars |tee $user_profile"_envars.log"
        $volatility_path -f $memory_path --profile=$user_profile hashdump |tee $user_profile"_hashdump.log"
        $volatility_path --plugin=$plugins -f $memory_path --profile=$user_profile mimikatz |tee $user_profile"_mimikatz.log"
        $volatility_path -f $memory_path --profile=$user_profile iehistory |tee $user_profile"_iehistory.log"
        $volatility_path -f $memory_path --profile=$user_profile svcscan |tee $user_profile"_svcscan.log"
        $volatility_path -f $memory_path --profile=$user_profile netscan |tee $user_profile"_netscan.log"
        $volatility_path -f $memory_path --profile=$user_profile connscan |tee $user_profile"_connscan.log"
        $volatility_path -f $memory_path --profile=$user_profile connections |tee $user_profile"_connections.log"
        $volatility_path -f $memory_path --profile=$user_profile sockets |tee $user_profile"_sockets.log"
        $volatility_path -f $memory_path --profile=$user_profile sockscan |tee $user_profile"_sockscan.log"
        $volatility_path -f $memory_path --profile=$user_profile hivelist |tee $user_profile"_hivelist.log"
        $volatility_path -f $memory_path --profile=$user_profile userassist |tee $user_profile"_userassist.log"
        $volatility_path -f $memory_path --profile=$user_profile shellbags |tee $user_profile"_shellbags.log"
        $volatility_path -f $memory_path --profile=$user_profile shimcache |tee $user_profile"_shimcache.log"
        $volatility_path -f $memory_path --profile=$user_profile yarascan |tee $user_profile"_yarascan.log"
        $volatility_path -f $memory_path --profile=$user_profile malfind |tee $user_profile"_malfind.log"
        $volatility_path -f $memory_path --profile=$user_profile clipboard -v |tee $user_profile"_clipboard.log"
        $volatility_path -f $memory_path --profile=$user_profile lsadump |tee $user_profile"_lsadump.log"
        #$volatility_path --plugin=$plugins -f $memory_path --profile=$user_profile openvpn |tee $user_profile"_openvpn.log"
        $volatility_path -f $memory_path --profile=$user_profile truecryptpassphrase |tee $user_profile"_truecryptpassphrase.log"
        $volatility_path -f $memory_path --profile=$user_profile truecryptsummary |tee $user_profile"_truecryptsummary.log"
        $volatility_path -f $memory_path --profile=$user_profile truecryptmaster |tee $user_profile"_truecryptmaster.log"
        $volatility_path --plugin=$plugins -f $memory_path --profile=$user_profile chromehistory |tee $user_profile"_chromehistory.log"
        $volatility_path --plugin=$plugins -f $memory_path --profile=$user_profile chromevisits |tee $user_profile"_chromevisits.log"
        $volatility_path --plugin=$plugins -f $memory_path --profile=$user_profile chromedownloads |tee $user_profile"_chromedownloads.log"
        $volatility_path --plugin=$plugins -f $memory_path --profile=$user_profile chromedownloadchains |tee $user_profile"_chromedownloadchains.log"
        $volatility_path --plugin=$plugins -f $memory_path --profile=$user_profile chromecookies |tee $user_profile"_chromecookies.log"
        #
        tput setaf 1;
        echo "Executing timeliner:"
        tput sgr 0;
        $volatility_path -f $memory_path --profile=$user_profile timeliner |tee $user_profile"_timeliner.log"
    else
        echo $background_proc;
    fi;
}
#function runLinuxPlugins(){
#
#}
#function runMacPlugins(){
#Nope
#}
####################
if [[ $# == 0 ]]
then
    help;
    exit 104;
fi;
if [[ $volatility_path == "" ]]
then
    volatility_path="volatility"
else
    volatility_path="python2 "$volatility_path
fi;
####################
if [[ $1 == "-h" ]]
then
    help;
    exit 104;
elif [[ $1 == "--info" ]]
then
    $volatility_path --info
    exit 0;
fi;
setFlags $@;
if [[ $user_profile == "" ]]
then
    echo "No user profile specified";
    $volatility_path imageinfo -f $memory_path imageinfo |tee imageinfo.log
    user_profile=`cat imageinfo.log |head -1 |cut -d ":" -f 2 |cut -d "," -f 1 |cut -d " " -f 2`
fi;
####################
if [[ `echo $user_profile|grep -i "^Win\|^Vista" |wc -l` >0 ]]
then
    echo Windows;
    runWindowsPlugins;
else
    i=0
    while [[ i -lt ${#Mac_profiles[@]} && `echo $user_profile |grep "^${Mac_profiles[$i]}" |wc -l` -eq 0 ]]
    do
        let "i=$i+1";
    done;
    if [[ $i -lt ${#Mac_profiles[@]} ]]
    then
        echo "You got fucked"
    else
        echo "Linux"
    fi;
fi;
#rm `file *.log | grep "empty$"|cut -d ":" -f 1`
exit 0;