set default-list
set default-script
set script-interpreter := ['bash', '-euo', 'pipefail']
set shell := ['bash', '-euo', 'pipefail', '-c']

export KUBECONFIG := justfile_directory() / "kubeconfig"
export TALOSCONFIG := justfile_directory() / "talosconfig"
export MINIJINJA_CONFIG_FILE := justfile_directory() / ".minijinja.toml"

export BAO_ADDR := "https://vault.youriulbri.ch:8200"

[group: 'Talos']
mod talos "talos"

[group: 'Bootstrap']
mod bootstrap "bootstrap"

[private]
log lvl msg *args:
    gum log -t rfc3339 -s -l "{{ lvl }}" "{{ msg }}" {{ args }}

[private]
template file *args:
    minijinja-cli "{{ file }}" {{ args }} | vals eval -f -

[private]
fetch-vault-token approle:
    initial_token=$(bao login -token-only -no-store)
    export BAO_TOKEN="$initial_token"

    role_id=$(bao read -field=role_id "auth/approle/role/{{approle}}/role-id")

    wrap_token=$(bao write -f -wrap-ttl=1s -format=json \
        "auth/approle/role/{{approle}}/secret-id" | jq -r '.wrap_info.token')

    secret_id=$(bao unwrap -field=secret_id "$wrap_token")

    session_token=$(bao write -field=token auth/approle/login \
        role_id="$role_id" secret_id="$secret_id")

    echo "$session_token"