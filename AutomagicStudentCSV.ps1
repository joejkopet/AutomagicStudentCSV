##############################################################
#  Script     : AutomagicStudentCSV
#  Author     : Joe Kopet
#  Date       : 03/05/2019
#  Last Edited: 03/11/2019, Joe Kopet
# https://github.com/joejkopet/AutomagicStudentCSV
##############################################################
# Purpose:
# Pulls data from a CSV file, adds the
# users to G Suite with a set password,
# OU and group membership.

# Changelog:
# 03/05/2019 - Modified original script for GitHub.
# 03/11/2019 - Slimmed down the script.

########## Begin Persistent Variables ##########
$ErrorActionPreference = 'SilentlyContinue' # Suppresses errors so the output is clean.
########## End Persistent Variables ##########

########## Begin Commands ##########
Set-Location C:\GAM #Sets Location to the GAM directory so GAM.exe can be executed.
########## End Commands ##########

########## Begin Functions ##########
function VerifyIfGoogleUserExists { # Define Function.
    $GamInfoUser = .\gam.exe info user $SamAccountName # Looks for the user in Google in our SAM format (firstname.lastname).
     If ($GamInfoUser -like "*User:*") {Write-Host "$Date : $DisplayNameProper ($GradYear) found in Google!" -ForegroundColor Yellow} # If there is a match (output) it will display that the user is found in Google.
     Else { (GoogleAccountCreation) # If there is no match (no output) jump to the GoogleAccountCreation function defined in functions.
     } #End If/Else.
} #End function.


function GoogleAccountCreation { #Define Function.
    $GoogleOU = "/students/$Building/$GradYear" # Defines the Google OU in the following format: /students/$Building/$GradYear
    Write-Host "$Date : Starting Google account creation for $DisplayNameProper" "($GradYear)."  -ForegroundColor Green # Outputs the user it is creating in Google.
  .\gam.exe create user $SamAccountName firstname $UserFirstname Lastname $UserLastname password $Password org $GoogleOU # Creates the user in Google in the organizational unit "/students/$GradYear"
  .\gam.exe update group Students-$GradYear add member user $SamAccountName # Adds the user to the Students-$GradYear group in Google.
  .\gam.exe update group Students-All add member user $SamAccountName # Adds the user to the Students-All group in Google.
  .\gam.exe update user $SamAccountName changepassword on # Password change on next login is required.
} #End Function.

########## End Functions ##########
$SISCSVFile = "C:\test.csv" # Enter the path to your CSV file here.
$Users = Import-CSV $SISCSVFile
foreach ($User in $Users) { 
    $Date = Get-Date
    $GradYear = $User.'Stu Grad Yr' # Pulls data from the Stu Grad Yr field in the CSV file.
    $Building = $User.'Cur School Name' # Pulls data from the Cur School Name field in the CSV file.
    $Displayname = $User.'Stu First Name' + " " + $User.'Stu Last Name' # Combines the Stu First Name field, inserts a space, and the Stu Last Name field in the CSV. Eg: JOHN SMITH.
    $Displayname = $Displayname -replace "-" # Removes all hyphens in the display name.
    $Displayname = $Displayname -replace "'" # Removes all apostrophes in the display name.        
    $UserFirstname = $User.'Stu First Name' # Pulls data from the Stu First Name field in the CSV file.
    $UserFirstName = $UserFirstName.substring(0,1).toupper()+$UserFirstName.substring(1).tolower() # Converts the first string to uppercase and the rest to lowercase. Eg: JOHN to John.
    $UserFirstname = $UserFirstname -replace "-" # Removes any hyphens in the firstname. Eg: John-VeryLongName Smith to Johnverylongname Smith.
    $UserFirstname = $UserFirstname -replace "'" # Removes any apostrophes in the firstname. Eg: J`ohn Smith to John Smith.          
    $UserLastname = $User.'Stu Last Name' # Pulls data from the Stu Last Name field in the CSV file.
    $UserLastName = $UserLastName.substring(0,1).toupper()+$UserLastName.substring(1).tolower() # Converts the first string to uppercase and the rest to lowercase. Eg: SMITH to Smith.
    $UserLastName = $UserLastName -replace "-" # Removes any hyphens in the lastname. Eg: John VeryLongName-Smith to John VerylongnameSmith.
    $UserLastName = $UserLastname -replace "'" # Removes any apostrophes in the lastname. Eg: John S`mith to John Smith.                               
    $Password = "examplepassword" # Sets the default password for the user.          
    $DisplayNameProper = $UserFirstName.substring(0,1).toupper()+$UserFirstName.substring(1).tolower() + " " + $UserLastName.substring(0,1).toupper()+$UserLastName.substring(1).tolower() # Converts the raw format JOHN SMITH to the proper format John Smith.
    $SamAccountName = $UserFirstname.ToLower() + '.' + $UserLastname.ToLower() # Adds a '.' between the first name and last name.
    $SamAccountName = $SamAccountName -replace '\s','' # Removes spaces.
    VerifyIfGoogleUserExists # Runs the VerifyIfGoogleUserExists function.
}
