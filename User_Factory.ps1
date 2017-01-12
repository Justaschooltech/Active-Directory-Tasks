#Script that allows you to make many AD users for testing purposes, or use some concepts to implement other tasks. 

#First import all the cmdlets we need to manipulate AD objects.
Import-Module ac*


#Set things up:
#Define how many users you want. Define username prefix. Users will be created in a prefix# format. So for 3 users with the prefix myuser the usernames will be myuser1, myuser2, myuser3
#Password is the password for the users. Each user will recieve the same password. 
# $Company will populate the ad attribute for company. You could expand and add many other attributes if needed. 
# $OU defines the OU the account will be placed into. 
$Ucount = read-host "Enter the number of users you want to create"
$NamePrefix = read-host "Enter the prefix name of the users you want to create"
$Password = read-host "Enter the password" 
$Company = read-host "Company"
$OU = read-host "Enter the OU to assign users to. Use this format OU=TestOU,DC=TestDomain"



#Now make the users. Looping as many times as needed and using the New-ADUser cmdlet to create the users.
For ($i=0; $i -le $Ucount-1 ; $i++)
{
    $Unumber = user($i +1)
    $Uname = $NamePrefix+$Unumber
    Write-host "Creating user" $Uname
    New-ADUser -Name $Uname -Path $OU -SamAccountName $Uname -DisplayName $Uname -Company $Company -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -ScriptPath "slogic" -Enabled $true
    }