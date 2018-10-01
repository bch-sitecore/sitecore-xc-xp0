# escape=`
FROM microsoft/dotnet-framework:4.7.2-sdk
SHELL ["powershell", "-Command", "$ErrorActionPreference='Stop';$ProgressPreference='SilentlyContinue';"]

RUN Add-WindowsFeature Web-Server; `
    Invoke-WebRequest "https://dotnetbinaries.blob.core.windows.net/servicemonitor/2.0.1.3/ServiceMonitor.exe" -OutFile "C:\ServiceMonitor.exe" -UseBasicParsing

EXPOSE 80

ENTRYPOINT ["C:\\ServiceMonitor.exe", "w3svc"]