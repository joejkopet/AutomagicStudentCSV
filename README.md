# AutomagicStudentCSV
Automates the creation of student G Suite accounts by using the CSV export from the SIS.

# Requirements
## Windows 10 or Windows Server 2016
## GAM 4.5+ 
   - `gam info domain` should generate output if GAM is setup correctly.
## A basic understanding of GAM and PowerShell is **strongly** recommended. 
## A basic understanding of your student information system (SIS) to export CSV files.

# How-To
**NOTE: This script assumes a firstname.lastname naming convention. The script will need to be modified for other naming conventions. In addition, this script is based off of a specific CSV formatting scheme. You will need to adjust this to your SIS CSV scheme.**

Download the AutomagicStudentCSV.ps1 file.
Right click - select edit - and make the following changes:
  - Line 20: `Set-Location C:\GAM` needs to be changed to where your gam.exe is located. 
  - Line 33: `$GoogleOU` needs to changed to the structure of your student OUs. I have listed /students/$Building/$GradYear as an example.
  - Lines 36-37: `group` may need to be changed depending on what groups your students go into. In this example, there is a Students-All group and a Students-$GradYear group.
  - Line 42: The location of your SIS CSV. Eg: "C:\test.csv"
  - Line 46-55: May need editing based on how your SIS formats the CSV export. Eg: ‘Stu Grad Year’ might not be the field for the student’s graduation year.
  - Line 61: `$Password` will need to be changed to your standard. 
Download the CSV export from your SIS.
Delete all values from your CSV file except for the headers. Add a test user in the fields. Eg:

    ![testcsv](https://github.com/joejkopet/AutomagicStudentCSV/blob/master/testcsv.PNG)

 Execute the script by running the following from a command prompt window: `powershell.exe -ExecutionPolicy Bypass    C:\AutomagicStudentCSV.ps1` (Change the path to where the script is saved). 

Verify the test user has been created. 

**A scheduled task can be created to automatically run this process. You will also need to automate the export of your SIS CSV which varies by SIS.**


# Screenshots
**Creating a user:**
    ![scriptoutputcreated](https://github.com/joejkopet/AutomagicStudentCSV/blob/master/scriptoutputcreated.PNG)

**Message when a user already exists:**
    ![scriptoutputfound](https://github.com/joejkopet/AutomagicStudentCSV/blob/master/scriptoutputfound.PNG)
