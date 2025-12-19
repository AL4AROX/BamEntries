$ErrorActionPreference = "SilentlyContinue"

# ============================================
# FUNCIÓN PARA MOSTRAR TEXTO CON ANIMACIÓN
# ============================================
function Write-AnimatedText {
    param(
        [string]$Text,
        [ConsoleColor]$Color = "White",
        [int]$Delay = 20,
        [switch]$NoNewline
    )
    
    if ($NoNewline) {
        foreach ($char in $Text.ToCharArray()) {
            Write-Host -NoNewline -ForegroundColor $Color $char
            Start-Sleep -Milliseconds $Delay
        }
    } else {
        foreach ($char in $Text.ToCharArray()) {
            Write-Host -NoNewline -ForegroundColor $Color $char
            Start-Sleep -Milliseconds $Delay
        }
        Write-Host ""
    }
}

# ============================================
# FUNCIÓN PARA BARRA DE PROGRESO
# ============================================
function Show-ProgressBar {
    param(
        [int]$Percent,
        [string]$Message,
        [int]$Width = 50
    )
    
    $completed = [math]::Round(($Percent * $Width) / 100)
    $remaining = $Width - $completed
    
    Write-Host "`r    [" -NoNewline -ForegroundColor Gray
    Write-Host ("█" * $completed) -NoNewline -ForegroundColor Cyan
    Write-Host ("░" * $remaining) -NoNewline -ForegroundColor DarkGray
    Write-Host "] " -NoNewline -ForegroundColor Gray
    Write-Host ("{0,3}%" -f $Percent) -NoNewline -ForegroundColor White
    Write-Host " $Message" -NoNewline -ForegroundColor Gray
}

# ============================================
# FUNCIÓN ORIGINAL (NO MODIFICADA)
# ============================================
function Get-Signature {
    [CmdletBinding()]
    param (
        [string[]]$FilePath
    )

    $Existence = Test-Path -PathType "Leaf" -Path $FilePath
    $Authenticode = (Get-AuthenticodeSignature -FilePath $FilePath -ErrorAction SilentlyContinue).Status
    $Signature = "Invalid Signature (UnknownError)"

    if ($Existence) {
        switch ($Authenticode) {
            "Valid" { $Signature = "✓ Firma Válida" }
            "NotSigned" { $Signature = "✗ No firmado" }
            "HashMismatch" { $Signature = "⚠ Hash mismatch" }
            "NotTrusted" { $Signature = "⚠ No confiable" }
            "UnknownError" { $Signature = "? Error desconocido" }
        }
        return $Signature
    } else {
        return "❌ No encontrado"
    }
}

# ============================================
# LIMPIAR Y CONFIGURAR PANTALLA
# ============================================
Clear-Host

# Configuración de ventana
try {
    $width = 80
    $height = 40
    if ($Host.UI.RawUI.WindowSize.Width -lt $width) {
        $Host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size($width, $height)
    }
} catch {}

# ============================================
# CABECERA ELEGANTE CON FIRMA
# ============================================
Write-Host ""
Write-Host "    ╔══════════════════════════════════════════════════════════╗" -ForegroundColor DarkCyan
Write-Host "    ║                                                          ║" -ForegroundColor DarkCyan
Write-Host "    ║        ██████╗  █████╗ ███╗   ███╗                       ║" -ForegroundColor Cyan
Write-Host "    ║        ██╔══██╗██╔══██╗████╗ ████║                       ║" -ForegroundColor Cyan
Write-Host "    ║        ██████╔╝███████║██╔████╔██║                       ║" -ForegroundColor Cyan
Write-Host "    ║        ██╔══██╗██╔══██║██║╚██╔╝██║                       ║" -ForegroundColor Cyan
Write-Host "    ║        ██████╔╝██║  ██║██║ ╚═╝ ██║                       ║" -ForegroundColor Cyan
Write-Host "    ║        ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝                       ║" -ForegroundColor Cyan
Write-Host "    ║                                                          ║" -ForegroundColor DarkCyan
Write-Host "    ║                ANALIZADOR DE ACTIVIDAD                   ║" -ForegroundColor White
Write-Host "    ║                  BACKGROUND (BAM)                        ║" -ForegroundColor White
Write-Host "    ║                                                          ║" -ForegroundColor DarkCyan
Write-Host "    ║                    by iRoxii 💻                          ║" -ForegroundColor Magenta
Write-Host "    ║                  ¡Disfruta! :3                           ║" -ForegroundColor Magenta
Write-Host "    ║                                                          ║" -ForegroundColor DarkCyan
Write-Host "    ╚══════════════════════════════════════════════════════════╝" -ForegroundColor DarkCyan
Write-Host ""

# ============================================
# INFORMACIÓN DEL SISTEMA
# ============================================
Write-AnimatedText -Text "    » Sistema detectado: " -Color Gray -Delay 10 -NoNewline
Write-AnimatedText -Text "$([Environment]::OSVersion.VersionString)" -Color White -Delay 20

Write-AnimatedText -Text "    » Usuario actual: " -Color Gray -Delay 10 -NoNewline
Write-AnimatedText -Text "$([Environment]::UserName)" -Color White -Delay 20

Write-AnimatedText -Text "    » Fecha y hora: " -Color Gray -Delay 10 -NoNewline
Write-AnimatedText -Text "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -Color White -Delay 20

Write-Host ""
Write-Host "    ───────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host ""

# ============================================
# BARRA DE CARGA INICIAL
# ============================================
Write-AnimatedText -Text "    ⚡ Inicializando sistema de análisis..." -Color Yellow -Delay 30
Write-Host ""

for ($i = 0; $i -le 100; $i += 5) {
    Show-ProgressBar -Percent $i -Message "Cargando módulos"
    Start-Sleep -Milliseconds 30
}
Write-Host ""
Write-Host "    ✅ Sistema inicializado correctamente" -ForegroundColor Green
Write-Host ""

# ============================================
# VERIFICACIÓN DE PERMISOS
# ============================================
function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

Write-AnimatedText -Text "    🔐 Verificando permisos de administrador..." -Color Cyan -Delay 30

if (-not (Test-Admin)) {
    Write-Host ""
    Write-Host "    ╔══════════════════════════════════════════════════════════╗" -ForegroundColor Red
    Write-Host "    ║                   PERMISOS INSUFICIENTES                 ║" -ForegroundColor Red
    Write-Host "    ╠══════════════════════════════════════════════════════════╣" -ForegroundColor Red
    Write-Host "    ║                                                        ║" -ForegroundColor Yellow
    Write-Host "    ║  Esta herramienta requiere ejecución como administrador ║" -ForegroundColor Yellow
    Write-Host "    ║                                                        ║" -ForegroundColor Yellow
    Write-Host "    ║  • Cierre esta ventana                                 ║" -ForegroundColor White
    Write-Host "    ║  • Ejecute PowerShell como administrador               ║" -ForegroundColor White
    Write-Host "    ║  • Vuelva a ejecutar el script                         ║" -ForegroundColor White
    Write-Host "    ║                                                        ║" -ForegroundColor Yellow
    Write-Host "    ║                                                        ║" -ForegroundColor Yellow
    Write-Host "    ║  🔧 Herramienta creada por iRoxii                      ║" -ForegroundColor Magenta
    Write-Host "    ║                                                        ║" -ForegroundColor Yellow
    Write-Host "    ╚══════════════════════════════════════════════════════════╝" -ForegroundColor Red
    
    Write-Host ""
    Write-Host "    ⏳ Cerrando en: " -NoNewline -ForegroundColor Red
    for ($i = 5; $i -gt 0; $i--) {
        Write-Host "$i " -NoNewline -ForegroundColor White
        Start-Sleep 1
    }
    Exit
}

Write-Host "    ✅ Permisos verificados" -ForegroundColor Green
Write-Host ""

# ============================================
# INICIAR ANÁLISIS
# ============================================
$sw = [Diagnostics.Stopwatch]::StartNew()

Write-Host "    ───────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-AnimatedText -Text "    🔍 Iniciando análisis BAM..." -Color Cyan -Delay 30
Write-Host ""

# Barra de progreso de análisis
Write-Host "    [" -NoNewline -ForegroundColor Gray
for ($i = 0; $i -lt 50; $i++) {
    Write-Host "▒" -NoNewline -ForegroundColor Cyan
    Start-Sleep -Milliseconds 20
}
Write-Host "] " -NoNewline -ForegroundColor Gray
Write-Host "PREPARADO" -ForegroundColor Green
Write-Host ""

# ============================================
# CÓDIGO DEL BAM PARSER (NO MODIFICADO)
# ============================================
if (-not (Get-PSDrive -Name HKLM -PSProvider Registry)) {
    try {
        New-PSDrive -Name HKLM -PSProvider Registry -Root HKEY_LOCAL_MACHINE
    } catch {
        Write-Host "    ⚠ Error accediendo al registro" -ForegroundColor Red
    }
}

$bv = @("bam", "bam\State")

try {
    Write-AnimatedText -Text "    📂 Explorando registros BAM..." -Color White -Delay 20
    $Users = foreach ($ii in $bv) {
        Get-ChildItem -Path "HKLM:\SYSTEM\CurrentControlSet\Services\$ii\UserSettings\" | Select-Object -ExpandProperty PSChildName
    }
    Write-Host "    📊 Entradas encontradas: " -NoNewline -ForegroundColor Gray
    Write-Host "$($Users.Count)" -ForegroundColor Cyan
} catch {
    Write-Host ""
    Write-Host "    ❌ Error: No se pudo acceder a las claves BAM" -ForegroundColor Red
    Write-Host "    ℹ  Posiblemente su versión de Windows no es compatible" -ForegroundColor Yellow
    Exit
}

$rpath = @(
    "HKLM:\SYSTEM\CurrentControlSet\Services\bam\",
    "HKLM:\SYSTEM\CurrentControlSet\Services\bam\state\"
)

$UserTime = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation").TimeZoneKeyName
$UserBias = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation").ActiveTimeBias
$UserDay = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation").DaylightBias

Write-Host "    🌍 Zona horaria: " -NoNewline -ForegroundColor Gray
Write-Host "$UserTime" -ForegroundColor White
Write-Host ""

# ============================================
# PROCESAMIENTO CON INTERFAZ MEJORADA
# ============================================
$totalProcessed = 0
$entryCount = 0
Write-AnimatedText -Text "    ⚙️  Procesando datos..." -Color Yellow -Delay 20
Write-Host ""

$Bam = foreach ($Sid in $Users) {
    foreach ($rp in $rpath) {
        $entryCount++
        Write-Host "    [" -NoNewline -ForegroundColor Gray
        Write-Host ("{0,3}" -f $entryCount) -NoNewline -ForegroundColor Cyan
        Write-Host "] " -NoNewline -ForegroundColor Gray
        Write-Host "SID: $($Sid.Substring(0, [math]::Min(12, $Sid.Length)))..." -ForegroundColor White
        
        $BamItems = Get-Item -Path "$rp\UserSettings\$Sid" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Property
        
        try {
            $objSID = New-Object System.Security.Principal.SecurityIdentifier($Sid)
            $User = $objSID.Translate([System.Security.Principal.NTAccount]).Value
        } catch {
            $User = "N/A"
        }

        foreach ($Item in $BamItems) {
            $totalProcessed++
            if ($totalProcessed % 5 -eq 0) {
                Write-Host "    ↳ Procesando entrada #$totalProcessed" -ForegroundColor DarkGray
            }
            
            $Key = Get-ItemProperty -Path "$rp\UserSettings\$Sid" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $Item
            if ($Key.Length -eq 24) {
                $Hex = [System.BitConverter]::ToString($Key[7..0]) -replace "-", ""
                $TimeLocal = Get-Date ([DateTime]::FromFileTime([Convert]::ToInt64($Hex, 16))) -Format "yyyy-MM-dd HH:mm:ss"
                $TimeUTC = Get-Date ([DateTime]::FromFileTimeUtc([Convert]::ToInt64($Hex, 16))) -Format "yyyy-MM-dd HH:mm:ss"
                $Bias = -([convert]::ToInt32([Convert]::ToString($UserBias,2),2))
                $Day = -([convert]::ToInt32([Convert]::ToString($UserDay,2),2))
                $TimeUser = (Get-Date ([DateTime]::FromFileTimeUtc([Convert]::ToInt64($Hex, 16))).AddMinutes($Bias) -Format "yyyy-MM-dd HH:mm:ss")

                $d = if ((Split-Path -Path $Item | ConvertFrom-String -Delimiter "\\").P3 -match '\d{1}') {
                    (Split-Path -Path $Item).Remove(23).TrimStart("\Device\HarddiskVolume")
                } else { "" }

                $f = if ((Split-Path -Path $Item | ConvertFrom-String -Delimiter "\\").P3 -match '\d{1}') {
                    Split-Path -Leaf ($Item.TrimStart())
                } else { $Item }

                $cp = if ((Split-Path -Path $Item | ConvertFrom-String -Delimiter "\\").P3 -match '\d{1}') {
                    $Item.Remove(1,23)
                } else { "" }

                $path = if ((Split-Path -Path $Item | ConvertFrom-String -Delimiter "\\").P3 -match '\d{1}') {
                    Join-Path -Path "C:" -ChildPath $cp
                } else { "" }

                $sig = if ((Split-Path -Path $Item | ConvertFrom-String -Delimiter "\\").P3 -match '\d{1}') {
                    Get-Signature -FilePath $path
                } else { "" }

                [PSCustomObject]@{
                    'Tiempo del examinador' = $TimeLocal
                    'Tiempo de ultima ejecucion (UTC)' = $TimeUTC
                    'Tiempo de ultima ejecucion (Hora del usuario)' = $TimeUser
                    Application = $f
                    Path = $path
                    Signature = $sig
                    User = $User
                    SID = $Sid
                    Regpath = $rp
                }
            }
        }
    }
}

# ============================================
# RESULTADOS FINALES ELEGANTES
# ============================================
$sw.Stop()
$t = [math]::Round($sw.Elapsed.TotalSeconds, 2)

Write-Host ""
Write-Host "    ───────────────────────────────────────────────────────────" -ForegroundColor Cyan
Write-Host "    📈 RESULTADOS DEL ANÁLISIS" -ForegroundColor White
Write-Host "    ───────────────────────────────────────────────────────────" -ForegroundColor Cyan
Write-Host ""

Write-Host "    ├─ Total de entradas: " -NoNewline -ForegroundColor Gray
Write-Host "$($Bam.Count)" -ForegroundColor Cyan

Write-Host "    ├─ Tiempo de análisis: " -NoNewline -ForegroundColor Gray
Write-Host "$t segundos" -ForegroundColor Cyan

Write-Host "    ├─ Zona horaria: " -NoNewline -ForegroundColor Gray
Write-Host "$UserTime" -ForegroundColor Cyan

Write-Host "    └─ Estado: " -NoNewline -ForegroundColor Gray
Write-Host "COMPLETADO ✓" -ForegroundColor Green

Write-Host ""
Write-Host "    ───────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host ""

if ($Bam.Count -gt 0) {
    Write-AnimatedText -Text "    📋 Generando vista interactiva de resultados..." -Color Yellow -Delay 20
    Write-Host "    💡 Puede ordenar y filtrar los datos en la tabla" -ForegroundColor Gray
    Write-Host ""
    
    # Mostrar tabla con estilo
    $title = "Análisis BAM by iRoxii | $($Bam.Count) entradas | $t segundos"
    $Bam | Out-GridView -PassThru -Title $title
    
    Write-Host ""
    Write-Host "    ✅ Análisis finalizado exitosamente" -ForegroundColor Green
} else {
    Write-Host "    ⚠ No se encontraron datos para analizar" -ForegroundColor Yellow
}

# ============================================
# PIE DE PÁGINA CON TU FIRMA
# ============================================
Write-Host ""
Write-Host "    ───────────────────────────────────────────────────────────" -ForegroundColor DarkCyan
Write-Host "    🔧 " -NoNewline -ForegroundColor Cyan
Write-Host "Herramienta desarrollada por " -NoNewline -ForegroundColor Gray
Write-Host "iRoxii" -ForegroundColor Magenta
Write-Host "    💖 " -NoNewline -ForegroundColor Cyan
Write-Host "¡Espero que la disfrutes! " -NoNewline -ForegroundColor Gray
Write-Host ":3" -ForegroundColor Magenta
Write-Host "    ⭐ " -NoNewline -ForegroundColor Cyan
Write-Host "Versión 2.0 | Análisis Forense Avanzado" -ForegroundColor Gray
Write-Host "    ───────────────────────────────────────────────────────────" -ForegroundColor DarkCyan

# Mensaje especial antes de salir
Write-Host ""
Write-AnimatedText -Text "    🎯 Gracias por usar mi herramienta. ¡Hasta la próxima!" -Color Cyan -Delay 30
Write-Host ""
Write-Host "    Presione cualquier tecla para finalizar..." -ForegroundColor Gray -NoNewline
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
