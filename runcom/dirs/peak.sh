#!/usr/bin/env zsh
#                                 d8b
#                                  ?88
#                                   88b
#   ?88,.d88b,  d8888b  d888b8b     888  d88'
#   `?88'  ?88 d8b_,dP d8P' ?88     888bd8P'
#     88b  d8P 88b     88b  ,88b   d88888b
#     888888P' `?888P' `?88P'`88b d88' `?88b,
#     88P'
#    d88      Directory Aliases
#   ?8P

# ===================
# --- Directories ---
# ===================

dir_base="$HOME/Code/brainbow"   # Where brainbow's repositories are located
dir_prefix='pk'                  # Alias prefix: ~PREFIX-REPO_NAME

typeset -A directories=(         # Directory paths and their aliases (lowercased)
  # Infrastructure
  ['AWSBatch']="$dir_base/aws-batch"
  ['AWSVPC']="$dir_base/aws-vpc"
  ['Infra']="$dir_base/terraform-infrastructure"
  ['Modules']="$dir_base/terraform-modules"

  # Core Services
  ['Billing']="$dir_base/sharper-billing/BillingServer"
  ['Game']="$dir_base/sharper-game/sharper-server"
  ['Identity']="$dir_base/brainbow-platform/identity/identity"
  ['Manifest']="$dir_base/manifest"
  ['SkuConfig']="$dir_base/peak-sku-config"
  ['Rating']="$dir_base/peak-rating"
  ['Feed']="$dir_base/peak-feed"

  # Core Dependencies
  ['Identity-Shared']="$dir_base/brainbow-platform/identity/shared"
  ['Monitoring']="$dir_base/sharper-monitoring/Monitoring"
  ['Configurations']="$dir_base/sharper-monitoring/SharperConfigurations"
  ['Database']="$dir_base/sharper-database"
  ['Message']="$dir_base/sharper-monitoring/SharperMessage"

  # Web Apps
  ['CSTool']="$dir_base/sharper-tools/CustomerServiceTool"
  ['Library']="$dir_base/sharper-platform/vignemal"
  ['WebPayments']="$dir_base/peak-web/vendors/NCServer"

  # Lambdas
  ['Lambdas']="$dir_base/sharper-platform/scripts"
  ['MailSender']="$dir_base/sharper-notificator/MailSender"
  ['Reducer']="$dir_base/sharper-monitoring/DashboardNode"
  ['Stripe']="$dir_base/sharper-platform/scripts/StripeWebhook"

  # Data
  ['Finance']="$dir_base/data-finance-peak"
  ['Peakalytics']="$dir_base/peakalytics"

  # Other
  ['Backend']="$dir_base/backend-dumping-ground"
  ['B2BCrons']="$dir_base/b2b-crons"
  ['Configuration']="$dir_base/peak-configuration"
  ['GDPR']="$dir_base/peak-gdpr"
  ['Net']="$dir_base/peak-net"
  ['Notificator']="$dir_base/sharper-notificator"
  ['Tools']="$dir_base/sharper-tools"
  ['Utils']="$dir_base/peak-utils"
)

# =================
# --- Execution ---
# =================

for dir_alias in ${(k)directories}; do
  typeset -l repo_name="$dir_alias"
  hash -d "${dir_prefix}-${repo_name}"="${directories[$dir_alias]}"
done

# ================
# --- Clean Up ---
# ================

unset dir_base dir_prefix directories dir_alias repo_name
