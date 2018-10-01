# escape=`
FROM microsoft/dotnet-framework:4.7.2-sdk
SHELL ["powershell", "-Command", "$ErrorActionPreference='Stop';$ProgressPreference='SilentlyContinue';"]

RUN Install-PackageProvider -Name 'NuGet' -Force ; `
    Install-Module –Name 'PowerShellGet' –Force ; `
    Register-PSRepository 'SitecoreGallery' -SourceLocation 'https://sitecore.myget.org/F/sc-powershell/api/v2' -InstallationPolicy Trusted

RUN Install-WindowsFeature Web-Server ; `
    Install-Module 'SitecoreInstallFramework' -Repository 'SitecoreGallery'

COPY ./dist /install
WORKDIR /install
RUN Install-SitecoreConfiguration -Path .\complete.json

RUN Invoke-WebRequest "https://dotnetbinaries.blob.core.windows.net/servicemonitor/2.0.1.3/ServiceMonitor.exe" -OutFile "C:\ServiceMonitor.exe" -UseBasicParsing
EXPOSE 80
ENTRYPOINT ["C:\\ServiceMonitor.exe", "w3svc"]