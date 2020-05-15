#!/usr/bin/env bash
if [[ $1 == "-h" ]];then
        echo "HELP"
        echo "-h                                     #查看帮助"
        echo "-f 文件名 -ho                     #统计访问来源主机TOP 100和分别对应出现的总次数"
        echo "-f 文件名 -ip                      #统计访问来源主机TOP 100 IP和分别对应出现的总次数"
        echo "-f 文件名 -u                     #统计最频繁被访问的URL TOP 100"
        echo "-f 文件名 -c                     #不同响应状态码的出现次数和对应百分比"
        echo "-f 文件名 -xx4                  #分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数"
        echo "-f 文件名 -uh url                            #给定URL输出TOP 100访问来源主机"
elif [[ $1 == "-f" ]];then
        IFS_old=$IFS
        IFS=$'\t'
        i=-1
        while read -r line;do
                array=($line)
                if [[ $i -gt -1 ]];then
                        host[$i]=${array[0]}
                        url[$i]=${array[4]}
                        code[$i]=${array[5]}
                fi
                ((i++))
                done < $2
                if [[ $3 == "-uh" ]];then
                        u=$4
                        echo "url为： $u"
                        cat $2 | awk -F'\t' ' $5=="'$u'" {printf"%s\n",$1}' | sort | uniq -c | sort -rn | head -n 100 | awk ' {printf(" %s\t\t 次数: %d\n",$2,$1)}'
                elif [[ $3 == "-xx4" ]];then
                        cat $2 | awk -F'\t' ' $6 ~/[4][0-9][0-9]/ {printf"%s\n",$5}'| sort | uniq -c | sort -rn | head -n 10 | awk '{printf(" %s\t\t\t %d 次\n",$2,$1)}'
                elif [[ $3 == "-c" ]];then
                        all=$(cat $2 | awk -F'\t' 'BEGIN{a=0} $6 ~/[0-9]/ {a=a+1} END {print a}')
                        echo $all
                        cat $2 | awk -F'\t' '$6 ~/[0~9]/ {print $6}' | sort | uniq -c | sort -rn | awk -F' ' '{printf("%s\t 次数:%d\t占 比 :%f \n",$2,$1,100*$1/'"${all}"')}'
                elif [[ $3 == "-u" ]];then
                        cat $2 | awk -F'\t' '{print $5}' | sort | uniq -c | sort -rn | head -n 100 | awk -F' ' '{printf(" %s\t\t 次数: %d\n",$2,$1)}'
                elif [[ $3 == "-ho" || $3 == "-ip" ]];then
                        dic1=($(echo ${host[*]} | sed 's/ /\n/g'|sort | uniq))
                        IFS=$'\n'
                        dic=($dic1)
                        declare -A hostnum
                        for v in ${dic}
                        do
                                hostnum[$v]=0
                        done
                        for v in ${host[@]}
                        do
                                x=${hostnum[$v]}
                                ((x++))
                                hostnum[$v]=$x
                        done
                        for key in "${!hostnum[@]}";do
                                if [[ $3 == "-ho" ]];then
                                        if [[ $key == *[a-zA-Z]* ]];then
                                                name[$i]=$key
                                                ((i++))
                                        fi
                                fi
                                if [[ $3 == "-ip" ]];then
                                        if [[ $key == *[a-zA-Z]* ]];then
                                                x=1
                                        else
                                                name[$i]=$key
                                                ((i++))
                                        fi
                                fi
                        done
                        echo "start"
                        t=${name[0]}
                        for((i=0;i<100;i++));
                        do
                                max=${hostnum[$t]}
                                m=$t
                                for v in ${name[@]};
                                do
                                        x=${hostnum[$v]}
                                        if [[ $x -gt $max ]];then
                                                max=$x
                                                m=$v
                                        fi
                                done
                                echo "TOP$((i+1)):  $m    次数： $max"
                                hostnum[$m]=-1
                        done
                else
                        echo "error"
                fi
        else
                echo "error"
        fi
