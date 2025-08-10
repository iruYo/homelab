#!/bin/sh
# https://r-pufky.github.io/docs/configuration-management/ansible/gpg-vault.html
gpg --batch --use-agent --decrypt $HOME/.vault/vault.gpg