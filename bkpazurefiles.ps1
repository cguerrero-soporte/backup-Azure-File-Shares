#Credenciales de dominio o de equipo 
$password = ConvertTo-SecureString 'Contraseña' -AsPlainText -Force
$credenciales = New-Object System.Management.Automation.PSCredential ('DOMINIO\Usuario', $password)

#Arreglo bidimencional. Se encapsulan los datos de ejecucion en el script.
$datos = @(
    [PSCustomObject]@{Numero = 1; Equipo = "Nombre de equipo"; Usuario = "Usuario"; Unidad = "https://unidadazure.file.core.windows.net/nonmbre de unidad?firma de acceso compartido"; Cuota = 5 },
    [PSCustomObject]@{Numero = 2; Equipo = "Nombre de equipo"; Usuario = "Usuario"; Unidad = "https://unidadazure.file.core.windows.net/nonmbre de unidad?firma de acceso compartido"; Cuota = 5 },
    [PSCustomObject]@{Numero = 3; Equipo = "Nombre de equipo"; Usuario = "Usuario"; Unidad = "https://unidadazure.file.core.windows.net/nonmbre de unidad?firma de acceso compartido"; Cuota = 5 }

)

$matriz = @()
foreach ($dato in $datos) {
    $fila = @(
        $dato.Equipo,
        $dato.Usuario,
        $dato.Unidad,
        $dato.Cuota
    )
    $matriz += ,$fila

    $equipo = $dato.Equipo
    $usuario = $dato.Usuario
    $unidad = $dato.Unidad
    $cuota = $dato.Cuota
    $extensiones1 = "*.xls", "*.xlsx", "*.docx", "*.doc", "*.txt", "*.pdf", "*.xml", "*.msg"
    $extensiones2 = "*.xls", "*.xlsx", "*.docx", "*.doc", "*.txt", "*.msg"
    $extensiones3 = "*.xls", "*.xlsx", "*.docx", "*.doc", "*.txt"
    $comando1 = "C:\Users\$usuario\azcopy.exe copy 'C:\Users\$usuario\Documents' '$unidad'--include-pattern ""*.xls;*.xlsx;*.docx;*.doc;*.txt;*.pdf;*.xml;*.msg"" --recursive"
    $comando2 = "C:\Users\$usuario\azcopy.exe copy 'C:\Users\$usuario\Documents' '$unidad'--include-pattern ""*.xls;*.xlsx;*.docx;*.doc;*.txt;*.msg"" --recursive"
    $comando3 = "C:\Users\$usuario\azcopy.exe copy 'C:\Users\$usuario\Documents' '$unidad'--include-pattern ""*.xls;*.xlsx;*.docx;*.doc;*.txt"" --recursive"
    
    Write-Output "===============Ejecutando respaldo en $equipo ==============="

    Invoke-Command -ComputerName $equipo -Credential $credenciales -ArgumentList $usuario, $unidad, $cuota,$extensiones1,$extensiones2,$extensiones3, $comando1, $comando2, $comando3 -ScriptBlock {
        param($usuario, $unidad, $cuota,$extensiones1,$extensiones2,$extensiones3, $comando1, $comando2, $comando3)

        $carpeta = "C:\Users\$usuario\Desktop"

        $size = Get-ChildItem -Path $carpeta -Include $extensiones1 -Recurse | Measure-Object -Property Length -Sum
        $bytes = $size.Sum
        $gigabytes = $bytes / 1GB

        if ($gigabytes -lt $cuota) {
            Write-Output "**********Se ejecuto comando 1**********"
            Invoke-Expression $comando1
            Write-Output "----------Se realizo respaldo con todos los archivos----------"
        }
        else {
            $size = Get-ChildItem -Path $carpeta -Include $extensiones2 -Recurse | Measure-Object -Property Length -Sum
            $bytes = $size.Sum
            $gigabytes = $bytes / 1GB

            if ($gigabytes -lt $cuota) {
                Write-Output "**********Se ejecuto comando 2**********"
                Invoke-Expression $comando2
                Write-Output "----------Se realizo respaldo sin archivos PDF y XML----------"
            }
            else {
                $size = Get-ChildItem -Path $carpeta -Include $extensiones3 -Recurse | Measure-Object -Property Length -Sum
                $bytes = $size.Sum
                $gigabytes = $bytes / 1GB

                if ($gigabytes -lt $cuota) {
                    Write-Output "**********Se ejecuto comando 3**********"
                    Invoke-Expression $comando3
                    Write-Output "----------Se realizo respaldo sin archivos PDF, XML y .msg----------"
                }
                else {
                    Write-Output "El tamaño de los archivos excede la capacidad de la nube."
                }
            }
        }
        
    }
}

