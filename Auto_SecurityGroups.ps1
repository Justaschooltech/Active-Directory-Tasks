
#This script allows you to automate adding or removing users to security groups based on some sort of criteria. Here we use the ad attribute department to determine if users should be added to the GradeOne group.
#This could be modified to test for different criteria. This contains no logic to determine if users is already part of the group but could   
#In this example the security group must already exist.  

#First import all the cmdlets we need to manipulate AD objects.  
import-module ac*

#A variable containing the group name and an array is populated using the Get-AdGroupMember cmdlet. 
$groupname = "GradeOneGroup"
$members = Get-ADGroupMember -Identity $groupname 

#Now we walk through the array testing each members department attribute. If the department attribute is not equal to "Grade 1" they should not be in the group and they are removed. Errors are
#logged to c:\Auto_SecurityGroups.log.
foreach($member in $members)
{
  
  Try 
  {
    $memberdetail = Get-ADUser $member -Properties department
   
    if($memberdetail.department -ne "Grade 1")
        {
            Remove-ADGroupMember -Identity $groupname -Member $member.SamAccountName -Confirm:$false -ErrorAction Stop
            "$member removed from $groupname" | Out-File c:\Auto_SecurityGroups.log -Append
        }
  } 
  
  catch 
  {
            "Failed to remove $member from $groupname" | Out-File c:\Auto_SecurityGroups.log -Append
  }
}


#Now we move onto adding users to the group.
#$users is populated by the Get-ADUser cmdlet with users that meet the filter requirement. This line looks at all users in AD but could easly be changed to look at targeted OUs
#Each user meeting membership requirement is then added to the group using the Add-ADGroupMember cmdlet. Error are logged. 
$users = Get-ADUser -Filter {Department -eq "Grade 1"}
foreach($user in $users)
{
    Try
    {
        Add-ADGroupMember -Identity $groupname -Members $user.samaccountname -ErrorAction Stop
        "$user added to $groupname" | Out-File c:\Auto_SecurityGroups.log -Append
    }

    catch
    {
        "Failed to add $user to $groupname" | Out-File c:\Auto_SecurityGroups.log -Append
    }
} 