Function Invoke-GreetingTask {
  Process {
    Write-TaskInfo -Message "Hello, world!" -Tag "greeting"
  }
}
Register-SitecoreInstallExtension -Command Invoke-GreetingTask -As Greeting -Type Task