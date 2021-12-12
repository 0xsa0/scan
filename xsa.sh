#!/bin/bash
echo -e "
      port scanner and dir fuzz
.-----------------------------------.
|     ###   #     #  #####     #    |
|    #   #   #   #  #     #   # #   |
|   # #   #   # #   #        #   #  |
|   #  #  #    #     #####  #     # |
|   #   # #   # #         # ####### |
|    #   #   #   #  #     # #     # |
|     ###   #     #  #####  #     # |
'-----------------------------------'
      Author : Saeed  &  Ibrahim 
" 
G="\e[32m"
########################
#                      #
#    Scanner           #
#                      #
########################
read -p  "Target IP : " url
read -p  "Enter your list : " word_list
read -p  "Enter extentaions  (ex:php,html,asp) : " exten

echo "#---- SCAN PORTS  ----#"
if [[ $? == 0 ]]
then
  for port in {1..500}; do
      timeout 1 bash -c  " 2>/dev/null echo > /dev/tcp/$url/$port"
      if [ $? == 0 ];then
          echo -n -e "${G}open port :: => " ; cat /etc/services | grep -m1  $port
      fi      
  done
fi

########################
#                      #
#    Fuzzing           #
#                      #
########################


arr_words=()
mapfile arr_words < $word_list


IFS="," read -a arr_ex <<< $exten

echo "#---- directories ----#"
for word in ${arr_words[@]};do

    word_test=$( curl -I -s  --write-out "%{http_code}\n"  "$url/$word" -o /dev/null )
    if [[ $word_test -eq 200 ]] || [[ $word_test -eq 301  ]];then
      echo "This : $word ------> [$word_test] ... [OK] "
    fi
done

echo "#---- extentions ----#"
for word in ${arr_words[@]};do
  for ex in ${arr_ex[@]};do
        ext_test=$( curl -I -s --write-out "%{http_code}\n" "$url/$word.$ex" -o /dev/null )
        if [[ $ext_test -eq 200 ]];then
          echo "Files : ------> [$word.$ex] ...  [OK] "
        fi
  done
done
