#### **1. WSL 설치**<br>
**1-1.** dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart<br>
**1-2.** dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart<br><br>

#### **2. WSL2 기본 버전으로 설정** <br>
**2-1.** wsl --set-default-version 2