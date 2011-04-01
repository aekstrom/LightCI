Properties {
    
	$build = "$root\Build"
    
	$artifacts = "$build\Artifacts"
    	$backup = "$build\Backup"
	$debug = "$build\Debug"
    
	$debug_site = "$debug\_PublishedWebsites\$project"
    
	$tools_7zip = "$root\Tools\7zip"
	$lib = "$root\Lib"
    
    $label = ([DateTime]::Now.ToString("d-M-yyyy HH-mm-ss"))
}

task Clean { 
  remove-item -force -recurse $artifacts -ErrorAction SilentlyContinue | Out-Null
  remove-item -force -recurse $backup -ErrorAction SilentlyContinue | Out-Null
  remove-item -force -recurse $debug -ErrorAction SilentlyContinue | Out-Null
}

task Init -depends Clean {
	if ((Test-Path $build) -eq $false) {
		New-Item -Path $build -ItemType Directory | Out-Null
	}
	 
    new-item $artifacts -itemType directory | Out-Null
    new-item $backup -itemType directory | Out-Null
    new-item $debug -itemType directory | Out-Null
}

task Compile -depends Init { 
  Exec { 
    msbuild /verbosity:minimal /p:Configuration="Release" /p:Platform="Any CPU" /p:OutDir="$debug"\\ $solution
  }
}

task Release -depends Compile {
	
  $exclude = @('Web.Debug.config','Web.Release.config')
  
  copy-item -Exclude $exclude "$debug_site\*" $artifacts -rec 
  
  copy-item -rec "$lib\*" "$artifacts/bin"
}

task Package -depends Release {
	&"$tools_7zip\7za.exe" a -t7z "$build\Build-$project $label.7z" "$artifacts\*"
}

task Upload -depends Release {
    UploadToFtp $artifacts $ftp_uri $ftp_user $ftp_pass 
}

task Backup {
    DownLoadFromFtp $backup $ftp_uri $ftp_user $ftp_pass
    &"$tools_7zip\7za.exe" a -t7z "$build\Backup-$project $label.7z" "$backup\*"
}