#Collects a list of users from a list of OUs and then concatenates their username with @YOURDOMAIN.com. This was used to quickly add an non domain email address to select users othermailbox attribute. 
#This could be modified in a number of ways including how it collects users and what attribute it writes. 

#First import all the cmdlets we need to manipulate AD objects.  
import-module ac*

#We can target a predefined list of OUs. The list of target OU's is stored in a CSV file.
#By creating an array and feeding it the data found in the csv file we now have an object containing data we can manipulate. 
#Instead of typing out Get-ADuser....-SearchBase OU=YourOU,DC=YourDomain for every OU the script automates it.  

#Here we import the csv file into an array called OUArray. Every element in the array is now a OU Path. 
#Here we also create an empty Array named ADUserArray. 
$OUArray = import-csv c:\YOURCSVFILE.csv
$ADUserArray = @()

#Now we need to look at each OU and get the samaccountname for each user object in that OU. 
#With each loop we examine a different OU and populate ADUserArray with the data provided by Get-ADUser
#-SearchBase $OUArray....is what is restricting the Get-ADUser search to the OU we desire.
#ALso only searching person objects. Should be more effecient then searching every object.  

for ($i=0; $i -le $OUArray.Length-1; $i++)
{
    $ADUserArray += Get-ADUser -Filter {ObjectCategory -eq "person"} -SearchBase $OUArray[$i].orgunit -Properties samaccountname | select -expand samaccountname
}

#Now that we have captured all the samaccountnames for all the user objects in all the OU's we looked at lets set the othermailbox. 
#We loop through our ADUserArray. Each element containts a samaccountname. We use that element data to tell Set-AdUser which users
#We also use that data to tell Set-ADUser what data to write to the othermailbox. Also concatenating @YOURDOMAIN.com at the same time.
#This could be updated to write any attribute.

for ($i=0; $i -le $ADUserArray.Length-1; $i++)
{
    Set-ADUser $ADUserArray[$i] -replace @{othermailbox=$($ADUserArray[$i])+"@YOURDOMAIN.com"}
}

#Trying to clean up any garbage left behind.  
$ADUserArray = $null
$OUArray = $null
[System.gc]::collect()
