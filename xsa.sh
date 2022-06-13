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
      Authors : Saeed  Alzahrani
" 

G="\e[32m"
ENDCOLOR="\e[0m"
showmenu () {
    echo "-------------"
    echo " 1. Port scan"
    echo " 2. Dir Fuzz"
    echo " 3. Quit"
    echo "-------------"
}
while true ; do
    showmenu
    read choices
    for choice in $choices ; do
        case "$choice" in
            1)
                read -p  "Target IP : " url
                echo "#---- SCAN PORTS  ----#"
                if [[ $? == 0 ]]
                then
                  for port in {79..111}; do
                      timeout 1 bash -c  " 2>/dev/null echo > /dev/tcp/$url/$port"
                      if [ $? == 0 ];then
                          echo -n -e "open port :: => " ; cat /etc/services | grep -m1  $port
                      fi      
                  done
                fi
                ;;
            2)
              read -p  "Target IP : " url
              read -p  "Enter your list : " word_list
              read -p  "Enter extentaions  (ex:php,html,asp) : " exten

              arr_words=()
              mapfile arr_words < $word_list
              IFS="," read -a arr_ex <<< $exten

              echo "#---- Directories ----#"
              
              for word in ${arr_words[@]};do
                
                  word_test=$( curl -I -s  --write-out "%{http_code}\n"  "$url/$word" -o /dev/null )
                  if [[ $word_test -eq 200 ]] || [[ $word_test -eq 301  ]];then
                    echo "Folder : $word ------> [$word_test] ... [  OK  ]"
                  fi
              done

              echo "#---- Extentions ----#"
              
              for word in ${arr_words[@]};do
                
                for ex in ${arr_ex[@]};do
                      ext_test=$( curl -I -s --write-out "%{http_code}\n" "$url/$word.$ex" -o /dev/null )
                      if [[ $ext_test -eq 200 ]];then
                        echo "Files : ------> [$word.$ex] ...  [  OK  ]"
                      fi
                done
              done
              ;;
            3)
                echo "Exit"
                exit 0 
                ;;
            *)
                echo "Please enter number ONLY ranging from 1-3!"
                ;;
        esac
    done
done
