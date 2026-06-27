# Terraform Multi-Cloud Infrastructure

Infrastructure-as-Code that provisions a single, VPN-meshed platform across **three
public clouds** with Terraform. It stands up the compute, networking, load balancing
and a site-to-site VPN needed to run a **highly-available Kubernetes cluster** and a
**distributed MariaDB (Galera) database** that span Oracle Cloud and Azure, and it
auto-generates the Ansible inventories used by the companion configuration repos.

The codebase is organised as a small set of reusable, provider-scoped modules with a
thin root configuration that wires them together and feeds them a declarative list of
servers — so scaling the fleet up or down is a one-line edit.

---

## What it provisions

| Cloud | Region | What gets created |
|-------|--------|-------------------|
| **Oracle Cloud (OCI)** | `us-phoenix-1` | VCN, public/private subnets across two ADs, IGW, NAT GW, DRG, security lists, **12 Ampere A1.Flex (ARM) instances**, a private **Network Load Balancer** for the Kubernetes API (`:6443`), and a public **Load Balancer** (`:443`) for ingress. |
| **Azure** | `westus3` | Resource group, VNet, private subnet + NSG, **8 `Standard_D2ps_v5` (ARM) Spot VMs**, an internal **Standard Load Balancer** for the Kubernetes API (`:6443`), and a public **Application Gateway** (`:443`) for ingress. |
| **AWS** | `us-east-1` | Remote-state backend (**S3** bucket + **DynamoDB** lock table) via `Backend_Module`, plus a standalone VPC/EC2 sample in `Aws_Module`. *(See "Remote backend bootstrap" — not wired into the active root by default.)* |
| **VPN mesh** | OCI ↔ Azure | Site-to-site **IPSec** with **two BGP tunnels** (Azure `VpnGw1` ⇄ OCI DRG), so the two clouds share one routable private network. |

The instance roles are derived from their hostnames (`*master*`, `*worker*`, `*db*`,
`*bastion*`), which in turn drive load-balancer backend selection and Ansible inventory
grouping.

---

## Architecture overview

```
                     ┌──────────────────────────────────────────────────┐
                     │            Remote state (AWS, us-east-1)          │
                     │   S3 bucket (versioned, AES256) + DynamoDB lock   │
                     │                  table  [Backend_Module]          │
                     └──────────────────────────────────────────────────┘
                                         ▲  state + locking
                                         │
                ┌────────────────────────┴─────────────────────────┐
                │                Terraform root config              │
                │  providers.tf · servers.tf · *_resources.tf · vpn │
                └───────────────┬───────────────────┬──────────────┘
                                │                   │
                                ▼                   ▼
   ┌─────────────────────────────────┐  ┌─────────────────────────────────┐
   │     Oracle Cloud — us-phoenix-1 │  │          Azure — westus3        │
   │  VCN 10.0.0.0/16                │  │  VNet 192.0.0.0/16              │
   │                                 │  │                                 │
   │  private subnet                 │  │  private subnet                 │
   │    12x A1.Flex ARM VM           │  │    8x D2ps_v5 ARM Spot VM       │
   │    (master / worker / db)       │  │    (master / worker / db)       │
   │  public subnets (AD2 + AD3)     │  │                                 │
   │    argocd / jenkins / bastion   │  │  internal LB  :6443  (k8s API)  │
   │                                 │  │  App Gateway  :443 ─► NodePort  │
   │  NLB (private) :6443  k8s API   │  │                (PFX cert)       │
   │  LB  (public)  :443 ─► NodePort │  │                                 │
   │                 (SSL cert)      │  │  VPN Gateway (VpnGw1, BGP 65515)│
   │  IGW · NAT · DRG  ◄───IPSec─────┼──┼───► VPN GW public IP            │
   │       (BGP ASN 31898)           │  │     2x IKEv2 tunnel, BGP        │
   └────────────────┬────────────────┘  └────────────────┬────────────────┘
                    │ outputs: IPs, roles                 │ outputs: IPs, roles
                    └──────────────────┬───────────────────┘
                                       ▼
                       ┌──────────────────────────────────┐
                       │          Inventory_Module         │
                       │  templatefile() → local_file →    │
                       │  Ansible inventories (sibling repos)│
                       └──────────────────────────────────┘

   Advanced per-tunnel BGP/IPSec settings that the OCI Terraform provider does not
   expose are applied by oci_vpn_advance_config/script.ts (OCI SDK) which the VPN
   module invokes through a null_resource local-exec provisioner.
```

**Traffic / data flow.** The OCI VCN (`10.0.0.0/16`) and the Azure VNet
(`192.0.0.0/16`) are joined by two BGP-routed IPSec tunnels, giving a flat private
network across clouds. Kubernetes control-plane traffic hits the per-cloud internal
load balancers on `:6443`; external ingress terminates TLS on each cloud's public load
balancer (`:443`) and is forwarded to the worker NodePort (`31736`). The VPN exists so
the MariaDB/Galera replicas stay in sync and so shared services (Jenkins, Argo CD, a
bastion) can be reached from either side.

---

## Module breakdown

```
.
├── providers.tf            # terraform block, provider aliases (aws/oci/azurerm), commented s3 backend
├── backend.tf              # (commented) call into Backend_Module to bootstrap remote state
├── variables.tf            # root inputs: ssh_key, oci_compartment_id, az_* creds, ssl_password
├── servers.tf              # declarative server lists: locals.oracleservers (12) + var.azureservers (8)
├── oracle_resources.tf     # wires the Oracle_Module sub-modules + outputs
├── azure_resources.tf      # wires the Azure_Module sub-modules + outputs
├── vpn.tf                  # wires the Vpn_Module (OCI ↔ Azure)
├── dynamic_inventory.tf    # wires the Inventory_Module
├── oci_vpn_advance_config/ # TypeScript helper for advanced OCI tunnel config (oci-sdk)
└── Modules/
    ├── Aws_Module/             # sample VPC + EC2 + EIP (standalone; not used by the active root)
    ├── Backend_Module/         # S3 (versioned, AES256) + DynamoDB (PAY_PER_REQUEST) for remote state
    ├── Inventory_Module/       # renders Ansible inventories via templatefile() + local_file
    ├── Vpn_Module/             # OCI CPE/IPSec + Azure VPN GW + local/connection gateways (2 BGP tunnels)
    ├── Oracle_Module/
    │   ├── network/            # VCN, subnets, IGW, NAT, DRG, route tables, security lists
    │   ├── compute/            # oci_core_instance (A1.Flex ARM) from a per-server input
    │   ├── k8sloadbalancer/    # private Network Load Balancer, TCP :6443, masters as backends
    │   └── publicloadbalancer/ # public Load Balancer, :443 ─► NodePort, workers as backends, SSL cert
    └── Azure_Module/
        ├── network/            # resource group, VNet, private subnet + NSG
        ├── compute/            # azurerm_linux_virtual_machine (ARM Spot) + NIC + cloud-init
        ├── k8sloadbalancer/    # internal Standard LB, TCP :6443, masters as backends
        └── publicloadbalancer/ # Application Gateway, :443 ─► NodePort, workers as backends, PFX cert
```

The `Oracle_Module/compute` and `Azure_Module/compute` modules are instantiated with
`for_each` over the server lists in `servers.tf`, and each emits a `server_details`
output (name, role booleans, IPs) that the load-balancer and inventory modules consume.

### The VPN helper (`oci_vpn_advance_config/`)
The OCI Terraform provider cannot set per-tunnel BGP routing, custom IKE phase-1/phase-2
parameters and DPD on an IPSec tunnel. `script.ts` fills that gap using the OCI Node SDK
(`oci-core` / `oci-common`) and `updateIPSecConnectionTunnel`. The `Vpn_Module` compiles
it (`tsc`) and runs it once per tunnel via `null_resource` `local-exec`, passing the
IPSec/tunnel OCIDs and the BGP interface IPs as arguments. A failed update now exits
non-zero so it surfaces as a Terraform error instead of being silently ignored.

---

## Prerequisites

- **Tooling:** Terraform CLI, plus **Node.js** and **TypeScript (`tsc`)** for the VPN
  helper (required only when `vpn.tf` is enabled).
- **OCI provider:** configured via the SDK/CLI config file or environment, per the
  [OCI Terraform provider docs](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm).
  Provide the target compartment OCID:
  ```bash
  export TF_VAR_oci_compartment_id="ocid1.compartment.oc1..."
  ```
- **Azure provider:** a service principal exported as environment variables (these map
  to the `az_*` variables and are marked `sensitive`):
  ```bash
  export TF_VAR_az_subscription_id="..."
  export TF_VAR_az_client_id="..."
  export TF_VAR_az_client_secret="..."
  export TF_VAR_az_tenant_id="..."
  ```
- **AWS credentials:** only needed for the remote backend (S3 + DynamoDB in
  `us-east-1`). Supply them via the standard AWS env vars, shared credentials file, or
  an instance profile.
- **SSH key:** a public key whose path is given to Terraform; it is injected into every
  OCI and Azure instance:
  ```bash
  export TF_VAR_ssh_key="$HOME/.ssh/id_ed25519.pub"
  ```
- **TLS material for the public load balancers** in `~/ssl/` (paths are referenced
  directly with `file()` / `filebase64()` in the code):
  | File | Used by |
  |------|---------|
  | `~/ssl/private.txt` + `~/ssl/certificate.txt` | OCI public Load Balancer certificate |
  | `~/ssl/cert.pfx` (PFX) | Azure Application Gateway listener |

  The PFX password is supplied (also `sensitive`) as:
  ```bash
  export TF_VAR_ssl_password="..."
  ```

---

## Remote backend bootstrap (S3 + DynamoDB)

State is stored remotely with S3 (versioned, server-side encrypted) and locked with
DynamoDB. Because Terraform cannot store state in a bucket that does not yet exist, this
is a two-phase, one-time bootstrap:

1. **Create the backend resources with local state.** Uncomment the `module "backend"`
   block in `backend.tf` (and set the `bucket_name` / `dynamodb_name`), then:
   ```bash
   terraform init
   terraform apply -target=module.backend
   ```
2. **Switch to the remote backend.** Uncomment the `backend "s3" { ... }` block in
   `providers.tf` so the `bucket`, `dynamodb_table`, `key` and `region` match what you
   just created, then migrate the existing local state into S3:
   ```bash
   terraform init -migrate-state
   ```

From then on every `plan`/`apply` reads and locks state remotely. Bootstrapping the
backend is optional — the configuration works with local state if you skip it.

---

## Usage

```bash
git clone https://github.com/Moody-san/terraform-multicloud-infra.git
cd terraform-multicloud-infra

terraform init
terraform plan
terraform apply
```

**Scaling the fleet** is done entirely in `servers.tf`: add or remove entries in
`locals.oracleservers` (OCI) or `var.azureservers` (Azure). Each entry's `display_name` /
`hostname` decides its role and therefore which load balancer pool and Ansible group it
joins.

### Optional toggles
- **Skip a cloud / feature** by commenting the corresponding root file:
  `azure_resources.tf` (Azure), `vpn.tf` (cross-cloud VPN), or `dynamic_inventory.tf`
  (Ansible inventory generation).
- **Regular vs Spot VMs (Azure):** comment the `priority` / `max_bid_price` /
  `eviction_policy` lines in `Modules/Azure_Module/compute/compute.tf` to provision
  on-demand instead of Spot VMs.

---

## Additional resources (companion repos)

The `Inventory_Module` writes Ansible inventories straight into these sibling repos:

- **Kubernetes setup:** [ansible-k8s-deployment](https://github.com/Moody-san/ansible-k8s-deployment)
- **MariaDB/Galera cluster:** [ansible-galeracluster-deployment](https://github.com/Moody-san/ansible-galeracluster-deployment)
- **CI/CD & controller automation:** [ansible-controller-setup](https://github.com/Moody-san/ansible-controller-setup)

## Demo & presentation

- Demo video: https://www.youtube.com/watch?v=HC4oogjLf64
- Slides: https://docs.google.com/presentation/d/1peuU2K6cA1b9EeZd8g-iz_ve9KucFXQJLtqBe5yV294/edit?usp=sharing

## Roadmap

- A Jenkins controller that watches this repo and applies infrastructure changes on
  commit (requires the remote backend above for shared state).
- More modular code with mockups for validating modules in isolation.
- Rethink the cross-cloud Galera topology: spreading one cluster across clouds makes a
  cloud read-only if the VPN drops, so either dedicate a separate cloud to the database
  or run two clusters (one per cloud) kept in sync.

---

> **Security note:** the demo security lists / NSGs are intentionally permissive
> (allow-all) to keep the walkthrough simple. Tighten ingress/egress rules before any
> non-demo use.
