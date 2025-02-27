Programme Ansible pour créer une infrastructure avec un AD, un serveur SQL et un serveur client Sage.

CONDITIONS:
        - Pouvoir taper le proxmox depuis la machine Ansible
        - Pouvoir taper les machines windows crée ou celle à lier
        - Faire gaffe au pfsense firewall

Comment utiliser le programme:

Tout d'abord éditer le ./inventory/AD-SQL-APP proxmox (ip du proxmox dans lequel créer l'infra)

Pour créer un AD seulement:
        - Editer roles/AD/vars/AD.yml
        - ansible-playbook -i ./inventory/AD ./playbooks/ad.yml
        - Attendre

Pour créer un Serveur SQL seulement:
        - Editer roles/SQL/vars/SQL.yml
        - ansible-playbook -i ./inventory/SQL ./playbooks/sql.yml
        - Attendre

Pour créer un serveur d'APLLI seulement:
        - Editer roles/APP/vars/APP.yml
        - ansible-playbook -i ./inventory/APP ./playbooks/app.yml
        - Attendre

Bien éditer les fichiers vars pour que toutes les ips soit en corrélation ainsi que les domaine et les nom des Ordinateurs
