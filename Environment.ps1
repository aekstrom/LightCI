$framework = '4.0'

Properties {
    	$root = [Environment]::CurrentDirectory

	$project = "AspNetMvc3Sample"
    	$solution = "$root\$project.sln"

	$ftp_uri = "ftp://127.0.0.1/"
    	$ftp_user = "web"
    	$ftp_pass = "web"
}

include .\Tools\PSake\ftp-ls.ps1
include .\Tools\PSake\main.ps1

task default -depends Release