# #!/usr/bin/env bash
#                                                                d8b
#                                          d8P           d8P    88P
#                                       d888888P      d888888P d88
#    d8888b  88bd88b?88   d8P ?88,.d88b,  ?88'  d8888b  ?88'   888
#   d8P' `P  88P'  `d88   88  `?88'  ?88  88P  d8P' `P  88P    ?88
#   88b     d88     ?8(  d88    88b  d8P  88b  88b      88b    88b
#   `?888P'd88'     `?88P'?8b   888888P'  `?8b `?888P'  `?8b    88b
#                         )88   88P'
#                        ,d8P  d88
#                     `?888P' ?8P

#  ~/.local/bin/cryptctl

# Author       : Chris-1101 @ GitHub
# Description  : Securely encrypt and decrypt strings using OpenSSL's symmetric cipher encoding
# Dependencies : openssl

# ===============
# --- Options ---
# ===============

typeset -r encryption='-aes-256-cbc'   # AES 256 bit Cipher Block Chaining
typeset -r key_derivation='-pbkdf2'    # Password-Based Key Derivation Function 2
typeset -ri iterations=100000          # Key Derivation Iterations - 10x Default
typeset -r digest='sha512'             # Secure Hash Algorithm 2 512 Digest
typeset -r base64='-a'                 # Base64 Encode After Encryption

# =================
# --- Functions ---
# =================

# Options
typeset -r options="$encryption $key_derivation -md $digest -iter $iterations $base64"

# Encrypt Data
function encrypt
{
  openssl enc -e $options -pass file:<(printf $password)
}

# Decrypt Data
function decrypt
{
  openssl enc -d $options -pass file:<(printf $password)
}

# Prompt User Input
function prompt_user
{
  # Prompt for Password
  read -s -p ':: Password: ' password
  printf $'\n'

  # Prompt for Data
  read -p ':: Data: ' data
  printf $'\n'
}

# =================
# --- Execution ---
# =================

# Parameters
case "$1" in
  -e | --enc ) prompt_user && encrypt <<< "$data" ;;
  -d | --dec ) prompt_user && decrypt <<< "$data" ;;
  *) printf '%s\n' 'Usage: cryptctl [--enc/--dec]' ;;
esac
