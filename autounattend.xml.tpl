<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State">
    <!--https://schneegans.de/windows/unattend-generator/?LanguageMode=Unattended&UILanguage=fr-FR&Locale=fr-FR&Keyboard=0000040c&GeoLocation=84&ProcessorArchitecture=amd64&ComputerNameMode=Random&TimeZoneMode=Explicit&TimeZone=Romance+Standard+Time&PartitionMode=Interactive&WindowsEditionMode=Interactive&UserAccountMode=Unattended&AutoLogonMode=Builtin&BuiltinAdministratorPassword=%7B%7Bvm_admin_pass%7D%7D&PasswordExpirationMode=Unlimited&LockoutMode=Default&WifiMode=Skip&ExpressSettings=DisableAll&WdacMode=Skip-->
    <settings pass="offlineServicing"></settings>
    <settings pass="windowsPE">
        <component name="Microsoft-Windows-International-Core-WinPE" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
            <SetupUILanguage>
                <UILanguage>fr-FR</UILanguage>
            </SetupUILanguage>
            <InputLocale>040c:0000040c</InputLocale>
            <SystemLocale>fr-FR</SystemLocale>
            <UILanguage>fr-FR</UILanguage>
            <UserLocale>fr-FR</UserLocale>
        </component>
        <component name="Microsoft-Windows-PnpCustomizationsWinPE" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" processorArchitecture="amd64" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <DriverPaths>
                <PathAndCredentials wcm:action="add" wcm:keyValue="1">
                    <Path>e:\amd64\2k22</Path>
                </PathAndCredentials>
            </DriverPaths>
        </component> 
        <component name="Microsoft-Windows-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
            <DiskConfiguration>
                <Disk wcm:action="add">
                    <CreatePartitions>
                        <CreatePartition wcm:action="add">
                            <Order>1</Order>
                            <Type>Primary</Type>
                            <Extend>true</Extend>
                        </CreatePartition>
                    </CreatePartitions>
                    <ModifyPartitions>
                        <ModifyPartition wcm:action="add">
                            <Format>NTFS</Format>
                            <Label>System</Label>
                            <Letter>C</Letter>
                            <Order>1</Order>
                            <PartitionID>1</PartitionID>
                        </ModifyPartition>
                    </ModifyPartitions>
                    <DiskID>0</DiskID>
                    <WillWipeDisk>true</WillWipeDisk>
                </Disk>
            </DiskConfiguration>
            <ImageInstall>
                <OSImage>
                    <InstallFrom>
                        <MetaData wcm:action="add">
                            <Key>/IMAGE/NAME</Key>
                            <Value>Windows Server 2022 SERVERDATACENTER</Value>
                        </MetaData>
                    </InstallFrom>
                    <InstallTo>
                        <DiskID>0</DiskID>
                        <PartitionID>1</PartitionID>
                    </InstallTo>
                </OSImage>
            </ImageInstall>
            <UserData>
                <ProductKey>
                    <!-- Do not uncomment the Key element if you are using trial ISOs -->
                    <!-- You must uncomment the Key element (and optionally insert your own key) if you are using retail or volume license ISOs -->
                    <!-- <Key>6XBNX-4JQGW-QX6QG-74P76-72V67</Key> -->
                    <WillShowUI>OnError</WillShowUI>
                </ProductKey>
                <AcceptEula>true</AcceptEula>
            </UserData>
        </component>
    </settings>
    <settings pass="generalize"></settings>
    <settings pass="specialize">
        <component name="Microsoft-Windows-Deployment" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
            <RunSynchronous>
                <RunSynchronousCommand wcm:action="add">
                    <Order>1</Order>
                    <Path>net.exe accounts /maxpwage:UNLIMITED</Path>
                </RunSynchronousCommand>
            </RunSynchronous>
        </component>
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
            <TimeZone>Romance Standard Time</TimeZone>
        </component>
    </settings>
    <settings pass="auditSystem"></settings>
    <settings pass="auditUser"></settings>
    <settings pass="oobeSystem">
        <component name="Microsoft-Windows-International-Core" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
            <InputLocale>040c:0000040c</InputLocale>
            <SystemLocale>fr-FR</SystemLocale>
            <UILanguage>fr-FR</UILanguage>
            <UserLocale>fr-FR</UserLocale>
        </component>
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
            <UserAccounts>
                <AdministratorPassword>
                    <Value>{{vm_admin_pass}}</Value>
                    <PlainText>true</PlainText>
                </AdministratorPassword>
            </UserAccounts>
            <AutoLogon>
                <Username>Administrateur</Username>
                <Enabled>true</Enabled>
                <LogonCount>1</LogonCount>
                <Password>
                    <Value>{{vm_admin_pass}}</Value>
                    <PlainText>true</PlainText>
                </Password>
            </AutoLogon>
            <OOBE>
                <ProtectYourPC>3</ProtectYourPC>
                <HideEULAPage>true</HideEULAPage>
                <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
            </OOBE>
            <FirstLogonCommands>
                <SynchronousCommand wcm:action="add">
                    <Order>1</Order>
                    <CommandLine>reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoLogonCount /t REG_DWORD /d 0 /f</CommandLine>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <CommandLine>e:\virtio-win-guest-tools.exe /quiet</CommandLine>
                    <Description>virtio-win-guest-tools Installation</Description>
                    <Order>3</Order>
                </SynchronousCommand> 
                <SynchronousCommand wcm:action="add">
                    <CommandLine>powershell -File f:\set-network.ps1</CommandLine>
                    <Description>Configure network</Description>
                    <Order>5</Order>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <CommandLine>powershell Start-Sleep -Seconds 30</CommandLine>
                    <Order>7</Order>
                </SynchronousCommand> 
{% if adds is match("enabled") %}
                <SynchronousCommand wcm:action="add">
                    <Order>11</Order>
                    <CommandLine>powershell -File f:\install-adds.ps1</CommandLine>
                </SynchronousCommand>
{% endif %}
                <SynchronousCommand wcm:action="add">
                    <Order>13</Order>
                    <CommandLine>powershell -File f:\EnableWinRm.ps1</CommandLine>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <CommandLine>powershell -File f:\DisableAutoServerManager.ps1</CommandLine>
                    <Order>14</Order>
                </SynchronousCommand>
{% if adds is match("disabled") %}
                <SynchronousCommand wcm:action="add">
                    <CommandLine>powershell Rename-Computer -NewName "{{computer_name}}" -Force -PassThru</CommandLine>
                    <Order>19</Order>
                </SynchronousCommand>
{% endif %}
                <SynchronousCommand wcm:action="add">
                    <CommandLine>powershell Start-Sleep -Seconds 60</CommandLine>
                    <Order>20</Order>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <CommandLine>powershell shutdown /s</CommandLine>
                    <Order>21</Order>
                </SynchronousCommand> 
            </FirstLogonCommands>
        </component>
    </settings>
</unattend>