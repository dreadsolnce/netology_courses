#!/bin/bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4 | bash
echo "Настройте вручную автодополнение комманд"
helm version

#***Автодополнение команд helm***
#
#```
#helm completion bash > ~/.helm_completion.sh
#```
#
#```
## add to .bashrc
#source ~/.helm_completion.sh
#```
#
#```
#source ~/.bashrc
#```
