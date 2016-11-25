# CheckYourHorizonViewInfra

Ce script permet de checker l'intégrité de l'infrastructure
VMWARE Horizon View à l'aide des moniteurs d'intégrité fournis
par les cmdlets PowerCli VMWARE.

## Les moniteurs d'intégrités sont les suivants:
CBMonitor = Contrôle l'intégrité des instances du Serveur de connexion View.
DBMonitor = Contrôle l'intégrité de la base de données des événements.
DomainMonitor = Contrôle l'intégrité du domaine local et de tous les domaines
approuvés de l'hôte du Serveur de connexion View.
SGMonitor = Contrôle l'intégrité des services de passerelle de sécurité et des
serveurs de sécurité.
VCMonitor = Contrôle l'intégrité des serveurs vCenter.

Pour afficher l'ensemble des propriétés tapez "get-monitor" dans une console
PowerCli ou après avoir chargé ce script

INFOS SUPPLEMENTAIRES (source: http://www.vmware.com/files/pdf/vmw-powershell-integration-view5.pdf):
Integrating VMware View PowerCLI into Your Own Scripts
You can load VMware View PowerCLI cmdlets directly for those situations where PowerShell scripts won’t be
run from the VMware View PowerCLI console. You can load cmdlets by dot-sourcing the add-snapin.ps1
script from the VMware Connection Server’s extras directory. Add the following line at the start of a script
using VMware View PowerCLI cmdlets:
. “<install directory>\Server\extras\PowerShell\add-snapin.ps1”
The VMware View Connection Server installation directory (noted above as <install directory>) will be
under the path C:\Program Files\VMware\VMware View\ by default.
Similar to launching from the Start Menu shortcut, this will also load the VMware vSphere PowerCLI cmdlets if
installed.
