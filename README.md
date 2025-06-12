# Création d'un environnement Sage fonctionnel avec un AD

Ce projet permet de déployer automatiquement une infrastructure Sage complète avec Active Directory via Ansible et Proxmox.

## 📋 Table des matières

- [Prérequis](#prérequis)
- [Configuration](#configuration)
- [Déploiement](#déploiement)
- [Structure du projet](#structure-du-projet)
- [Résultats](#résultats)

## 🔧 Prérequis

Avant de pouvoir utiliser cette solution d'automatisation, plusieurs conditions doivent être remplies :

### Authentification SSH
- Exécuter `ssh-copy-id` sur la machine Ansible vers le Proxmox où créer les VMs
- Sinon, préciser le mot de passe en clair dans le fichier inventaire (déconseillé)

### Réseau
- La machine Ansible doit être sur le même réseau que les machines Windows à créer

### Firewall
- Vérifier les règles du firewall si le déploiement ne fonctionne pas

## ⚙️ Configuration

### 1. Fichiers d'inventaire

Éditer les fichiers `inventory/(AD,SQL,APP)` qui contiennent :
- L'IP du Proxmox pour créer l'infrastructure
- Le nom d'utilisateur Proxmox (éviter l'utilisateur root si possible)

> ⚠️ **Note :** Le fichier hosts Windows sera modifié automatiquement par les scripts, ne pas le modifier manuellement !

### 2. Variables générales (host_vars/proxmox)

Configurer les variables communes aux 3 machines :

```yaml
os_iso_location: "DISK01:iso/windows2022.iso"  # Emplacement Proxmox de l'ISO Windows
pve_storage_id: "DISK01"                       # Nom du disque de stockage
vm_cores: 4                                    # Cœurs CPU
vm_sockets: 1                                  # Sockets CPU
vm_memory_mb: 8192                            # RAM en Mo
vm_prefix: 24                                 # Masque réseau (0-24)
```

### 3. Configuration Active Directory (vars/ad.yml)

```yaml
vm_id: 12555                    # ID de la VM sur Proxmox
computer_name: "AD-SERVER"      # Nom de l'ordinateur Windows
template_name: "Template-AD"    # Nom affiché sur Proxmox
vm_admin_pass: "MotDePasse123"  # Mot de passe admin local Windows
drive_size_gb: 32               # Capacité du disque en Go
vm_bridge: "VLAN100"           # VLAN réseau
vm_ip: "192.168.1.10"          # IP de la machine
vm_gw: "192.168.1.1"           # Passerelle par défaut
dns: "8.8.8.8"                 # DNS (8.8.8.8 ou 9.9.9.9 pour l'AD)
adds: "enabled"                 # Doit être "enabled" pour l'AD
domain_ad: "mondomaine"         # Nom du domaine
orga_name: "MonEntreprise"      # Nom entreprise pour les utilisateurs/groupes
```

### 4. Configuration Serveur SQL (vars/sqlserver.yml)

Variables supplémentaires :

```yaml
ad_admin_pass: "MotDePasseAD"           # Mot de passe AD pour connexion domaine
sql_iso_location: "DISK01:iso/sql.iso"  # Emplacement ISO SQL
dns: "192.168.1.10"                     # IP de l'AD pour liaison domaine
sql_pass: "MotDePasseSQL"               # Mot de passe base SQL (utilisateur 'sa')
```

### 5. Configuration Serveur d'Application (vars/srvappli.yml)

Variables supplémentaires :

```yaml
ad_admin_pass: "MotDePasseAD"    # Mot de passe AD
dns: "192.168.1.10"              # IP de l'AD
sql_pass: "MotDePasseSQL"        # Mot de passe SQL
tsplus: true                     # Installation TSplus
cle1: "XXXXX"                    # Clé Sage partie 1
cle2: "XXXXX"                    # Clé Sage partie 2
cle3: "XXXXX"                    # Clé Sage partie 3
raison_sociale: "Mon Entreprise"
adresse1: "123 Rue Example"
code_postale: "75000"
ville: "Paris"
telephone: "0123456789"
siret: "12345678901234"
```

#### Applications optionnelles

Définir à `true` pour installer :
- `malwarebytes`
- `sage`
- `tsplus`
- `chrome`
- `firefox`
- `sevenzip`
- `notepadplusplus`

## 🚀 Déploiement

### Méthode 1 : Avec fichiers de configuration

#### 1. Créer l'Active Directory
```bash
ansible-playbook -i inventory/AD playbooks/ad.yml
```

#### 2. Créer le serveur SQL
```bash
ansible-playbook -i inventory/SQL playbooks/sql.yml
```

#### 3. Créer le serveur d'application
```bash
ansible-playbook -i inventory/APP playbooks/app.yml
```

### Méthode 2 : En ligne de commande

Exemple pour créer un AD :

```bash
ansible-playbook -i inventory/AD playbooks/ad.yml \
  -e "os_iso_location=ZPOOL-FREENASHDD01:iso/SW_DVD9_Win_Server_STD_CORE_2022_2108.9_64Bit_French_DC_STD_MLF_X23-14510.ISO" \
  -e "pve_storage_id=ZPOOL-FREENASHDD01" \
  -e "vm_cores=2" \
  -e "vm_sockets=2" \
  -e "vm_memory_mb=8192" \
  -e "vm_prefix=24" \
  -e "vm_id=12555" \
  -e "template_name=Alt-AD" \
  -e "computer_name=Alt-AD" \
  -e "vm_admin_pass=XXXX" \
  -e "domain_ad=alternance" \
  -e "orga_name=Alternance" \
  -e "drive_size_gb=32" \
  -e "vm_bridge=VLANXXXX" \
  -e "vm_ip=XX.XX.XX.XX" \
  -e "vm_gw=XX.XX.XX.XX" \
  -e "dns=8.8.8.8" \
  -e "adds=enabled"
```

## 📁 Structure du projet

```
proxmox-deploiement/
├── host_vars/
│   └── proxmox.yml
├── inventory/
│   ├── AD
│   ├── SQL
│   └── APP
├── playbooks/
│   ├── ad.yml
│   ├── app.yml
│   └── sql.yml
├── roles/
│   ├── AD/
│   │   ├── files/
│   │   │   ├── DisableAutoServerManager.ps1
│   │   │   └── EnableWinRm.ps1
│   │   ├── tasks/
│   │   │   ├── cleanup.yml
│   │   │   ├── config.yml
│   │   │   ├── login_admin.yml
│   │   │   └── VM.yml
│   │   ├── templates/
│   │   │   ├── install-adds.ps1.j2
│   │   │   └── set-network.ps1.j2
│   │   └── vars/
│   │       └── AD.yml
│   ├── APP/
│   │   ├── files/
│   │   │   ├── DisableAutoServerManager.ps1
│   │   │   ├── EnableWinRm.ps1
│   │   │   └── SetupErp1011Auto.iss
│   │   ├── tasks/
│   │   │   ├── ajout_domaine.yml
│   │   │   ├── cleanup.yml
│   │   │   ├── config.yml
│   │   │   ├── desac_winrm.yml
│   │   │   ├── malwarebyte.yml
│   │   │   ├── modif_host.yml
│   │   │   ├── sage.yml
│   │   │   ├── tsplus.yml
│   │   │   └── VM.yml
│   │   ├── templates/
│   │   │   ├── set-network.ps1.j2
│   │   │   ├── SetupCli.iss.j2
│   │   │   └── SetupErp1000.iss.j2
│   │   └── vars/
│   │       └── APP.yml
│   └── SQL/
│       ├── files/
│       │   ├── DisableAutoServerManager.ps1
│       │   ├── EnableWinRm.ps1
│       │   └── SetupSQL.iss
│       ├── tasks/
│       │   ├── ajout_domaine.yml
│       │   ├── cleanup.yml
│       │   ├── config.yml
│       │   ├── desac_winrm.yml
│       │   ├── modif_host.yml
│       │   ├── ServSage.yml
│       │   ├── SQL2017.yml
│       │   └── VM.yml
│       ├── templates/
│       │   └── set-network.ps1.j2
│       └── vars/
│           └── SQL.yml
├── ansible.cfg
├── autounattend.xml.tpl
└── README.md
```

### Description des composants principaux

| Fichier/Dossier | Description |
|-----------------|-------------|
| `ansible.cfg` | Configuration Ansible (spécifie le fichier hosts) |
| `autounattend.xml.tpl` | Template de configuration Windows pour l'installation automatique |
| `inventory/` | Fichiers hosts spécifiant le Proxmox et les VMs Windows |
| `host_vars/` | Variables Proxmox communes (ex: ISO Windows Server 2022) |
| `playbooks/` | Scripts de création des machines |
| `roles/*/tasks/` | Tâches spécifiques pour chaque machine (installation d'applications) |

## 🎯 Résultats

À la fin des scripts, vous obtiendrez :
- ✅ Machines fonctionnelles capables de lancer les applications métiers Sage100
- ✅ Applications : comptabilité, trésorerie, etc.
- ✅ Gestion d'utilisateurs avec groupe Sage
- ✅ Droits d'accès aux fichiers configurés

## 🔗 Liens

- **Dépôt GitHub :** https://github.com/Sharmite/Proxmox-deploiement

## 🤝 Contribution

Les contributions sont les bienvenues ! N'hésitez pas à ouvrir une issue ou soumettre une pull request.

---

**Note :** Assurez-vous de personnaliser toutes les variables selon votre environnement avant le déploiement, les variables utilisées sont des exemples et seront différentes pour tous.