# ------------------------------------------------------------------------
# NOM: check_Horizon_View_Integrity.ps1
# AUTEUR: Antonio de Almeida
# DATE:30/09/2015
# Version: 1.0
#
# COMMENTAIRES: 
# Ce script permet de checker l'intégrité de l'infrastructure
# VMWARE Horizon View à l'aide des moniteurs d'intégrité fournis
# par les cmdlets PowerCli VMWARE.
#
# Les moniteurs d'intégrités sont les suivants:
# CBMonitor = Contrôle l'intégrité des instances du Serveur de connexion View.
# DBMonitor = Contrôle l'intégrité de la base de données des événements.
# DomainMonitor = Contrôle l'intégrité du domaine local et de tous les domaines
# approuvés de l'hôte du Serveur de connexion View.
# SGMonitor = Contrôle l'intégrité des services de passerelle de sécurité et des
# serveurs de sécurité.
# VCMonitor = Contrôle l'intégrité des serveurs vCenter.
#
# Pour afficher l'ensemble des propriétés tapez "get-monitor" dans une console
# PowerCli ou après avoir chargé ce script
#
# INFOS SUPPLEMENTAIRES (source: http://www.vmware.com/files/pdf/vmw-powershell-integration-view5.pdf):
# Integrating VMware View PowerCLI into Your Own Scripts
# You can load VMware View PowerCLI cmdlets directly for those situations where PowerShell scripts won’t be
# run from the VMware View PowerCLI console. You can load cmdlets by dot-sourcing the add-snapin.ps1
# script from the VMware Connection Server’s extras directory. Add the following line at the start of a script
# using VMware View PowerCLI cmdlets:
# . “<install directory>\Server\extras\PowerShell\add-snapin.ps1”
# The VMware View Connection Server installation directory (noted above as <install directory>) will be
# under the path C:\Program Files\VMware\VMware View\ by default.
# Similar to launching from the Start Menu shortcut, this will also load the VMware vSphere PowerCLI cmdlets if
# installed.
# --------------------------------------------------------------------

CLEAR

#Chargement des cmdlets VMWARE Horizon View via un dot sourcing
."C:\Program Files\VMware\VMware View\Server\extras\PowerShell\add-snapin.ps1"

#Récuperation de l'ensemble des moniteurs avec les propriétés voulues
$IntegrityMonitors = Get-Monitor | select Monitor,fullname,isalive,statusValues,state,iscomposerenabled,isProblem,connected,certValid,certAboutToExpire,totalsessions,server,error,monitor_id

# CODES RETOUR NAGIOS
$OK=0
$WARNING=1
$CRITICAL=2
$UNKNOWN=3


#Fonction générique permettant le check des moniteurs
function checkMonitor($monitorName,$property01,$value01)
{
    foreach($x in $IntegrityMonitors)
        {
           if($x.monitor -eq $monitorName)
           {
               if($x.($property01) -eq $value01)
               {
               $script:extended_info +=  $x.fullname +": " +$property01 +" is "+ $x.($property01)+"`n"; $CRITICAL
               return $CRITICAL
               }else{$script:extended_info += $x.fullname +": " +$property01 +" is "+ $x.($property01)+"`n";  $ok}
          
           }
     
        }       
}


#Appel des fonctions

$CBMonitorChecking = checkMonitor "CBMonitor" "isAlive" "false"
$DBMonitorChecking = checkMonitor "DBMonitor" "state" "DISCONNECTED"
$DomainMonitorChecking = checkMonitor "DomainMonitor" "isProblem" "true" 
$SGMonitorChecking = checkMonitor "SGMonitor" "isAlive" "false"
$VCMonitorChecking = checkMonitor "VCMonitor" "state" "ERROR"

#Vérification finale en vue d'effectuer le code retour adapté
if(($CBMonitorChecking -or $DBMonitorChecking -or $DomainMonitorChecking -or $SGMonitorChecking -or $VCMonitorChecking) -eq $CRITICAL)
{
    Write-Host "Problème d'intégrité de l'infrastructure Horizon View"
    Write-Host $extended_info
    exit $CRITICAL
}else{Write-Host "Intégrité de l'infrastructure Horizon View OK";Write-Host $extended_info; exit $OK}
