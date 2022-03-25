#Script to do bulk Azure B2B invites and provision group based access to SSO app such as webex
#Example input CSV
##FirstName,LastName,DisplayName,InvitedUserEmailAddress
##Keith,Anderson,Keith Anderson,keith.anderson@contoso.com

$invitations = import-csv c:\temp\AzurePowerShell\invitations.csv

foreach ($email in $invitations)
   {New-AzureADMSInvitation `
      -InvitedUserEmailAddress $email.InvitedUserEmailAddress `
      -InvitedUserDisplayName $email.DisplayName `
      -InviteRedirectUrl https://contoso.webex.com ` #Company Webex URL
      -SendInvitationMessage $false
   $user = Get-AzureADUser -SearchString $email.InvitedUserEmailAddress
   Set-AzureADUser `
	  -ObjectId $user.objectid `
	  -Surname $email.LastName `
	  -GivenName $email.FirstName
   Add-AzureADGroupMember `
      -ObjectId 4d8ca214-ce66-45b5-8f3a-8ad3d7a35a05 ` #group for provisioning Webex access
	  -RefObjectId $user.objectid
   }
