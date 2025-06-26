#!/bi/bash

get_modem_number() {
    IFS='/ ' read -r _ _ _ mm _ mn mt < <(mmcli -L)
#   echo 'echo: Modem number is' $mn
    printf "Modem number is: %s\n" $mn
}
