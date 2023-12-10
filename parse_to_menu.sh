#!/bin/bash

# shellcheck disable=SC2089
RAW='{"items":{"item":[{"batters":{"batter":[{"id":"1001","type":"Regular"},{"id":"1002","type":"Chocolate"},{"id":"1003","type":"Blueberry"},{"id":"1004","type":"Devils Food"}]},"id":"0001","name":"Cake","ppu":0.55,"topping":[{"id":"5001","type":"None"},{"id":"5002","type":"Glazed"},{"id":"5005","type":"Sugar"},{"id":"5007","type":"Powdered Sugar"},{"id":"5006","type":"Chocolate with Sprinkles"},{"id":"5003","type":"Chocolate"},{"id":"5004","type":"Maple"}],"type":"donut"}]}}'

echo "$RAW" | jq -rc '.items.item[].batters.batter[]'
amount=$(echo "$RAW" | jq -rc '.items.item[].batters.batter[]' | wc -l)

# shellcheck disable=SC2207
IFS=";" menu=($(echo "$RAW" | jq -r '.items.item[].batters.batter[] | { id, type } | .id+";"+.type+";OFF"' | tr '\n' ';'))
echo ---
echo "${menu[@]}"
echo ---
choice=$(whiptail --separate-output --checklist "Chose what you want:" 20 80 "$amount" "${menu[@]}" 3>&1 1>&2 2>&3)

echo "$choice" | while read -r item; do
    echo Key: "$item"
    for((i=0;i<amount;i++));do
        if [[ "$item" = "${menu[$((i*3))]}" ]];then
            echo Value: "${menu[$((i*3 + 1))]}"
            break
        fi
    done
done