# Backup Azure File Shares
Respaldo automático de documentos desde un equipo local hacia un almacenamiento compartido en Azure ![image](https://github.com/cguerrero-soporte/backup-azure-fileshare/assets/54060479/ea4b532d-bd19-4c30-9a88-d7ebc82c5ce2)
, verificando la cuota de la unidad para seleccionar el tipo de copia.

Para obtener la firma de acceso compartido, es necesario acceder a Microsoft Azure Storage Explorer. Luego, dirígete a "Cuentas de Almacenamiento" y selecciona el nombre de la cuenta deseada. A continuación, navega hasta la sección "File Shares" y haz clic derecho sobre la unidad deseada. En el menú desplegable, elige la opción "Obtener firma de acceso compartido".

*Importante
Agregar permisos de "Crear" y "Escribir" 
![image](https://github.com/cguerrero-soporte/backup-azure-fileshare/assets/54060479/6a7655ca-5d59-44d1-b032-73b6da88b447)

Extender la fecha de uso en caso de ser necesario
