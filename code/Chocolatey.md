#### **Chocolatey 패키지 관리자 설치** <br>
**1.** Set-ExecutionPolicy Bypass -Scope Process -Force<br>
**2.** [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072<br>
**3.** iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
