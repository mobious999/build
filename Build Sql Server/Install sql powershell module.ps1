#######################################################################################################
#Auto Load SQL PS Module
#The included SQL module isn't kept up to date, so we're going to install the latest module from MS git
Install-Module sqlserver -AllowClobber
#Import the module
Import-Module sqlserver -DisableNameChecking
#End Auto Load SQL PS Module
#######################################################################################################
