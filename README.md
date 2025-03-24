# Caso #1 - Entregable 12 ![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
## Payment Assistant
Imagina un asistente personal que no solo recuerda tus pagos recurrentes, sino que también los ejecuta por ti con solo confirmar un recordatorio. Con tecnología de inteligencia artificial de vanguardia, nuestra app te permite registrar y programar pagos de servicios como luz, agua, renta y más, usando simplemente tu voz. Olvídate de fechas vencidas, multas o estrés financiero. Además, con planes flexibles que se adaptan a tus necesidades, disfrutas de una experiencia gratuita para un pago mensual y opciones premium para múltiples transacciones.

#### Notas Importantes:
Para la revisión de los archivos adjuntos, se recomienda descargar el PDF para mejorar su visualización.

## Lista de Entidades
A continuación se listan todas las entidades relevantes a la creación de las tablas en MySQL Workbench.
- Usuarios y sus perfiles respectivos:
    * Nombre y apellido
    * Información de contacto adicional (numero telefónico, Instagram, correo, etc)
- Permisos administrativos y de consumidor (incluyendo accesos, grants y denies)
- Almacenamiento de archivos (attachments, media files, documentos, URLs bancarios, etc)
- Transacciones y pagos
    * Monto
    * Moneda
    * Fecha
    * Resultado
    * Autenticador
    * Descriptión
    * Manejo de errores
    * Tipo de transacción
- Suscripciones, planes y sus costo/límites/features respectivos
- Bitácora
    * Pagos intentados, fallidos y exitosos
    * Montos, métodos de pago, fechas y cuenta de origen
- Scheduling
- Internacionalización
- Manejo de cambios entre sistemas monetarios (dólar, colones, pesos, etc.)


## Scripts

### Creación de Base de Datos


### Llenado de Datos
```sql
use paymentAssistant;

DROP TEMPORARY TABLE IF EXISTS tempNames;
CREATE TEMPORARY TABLE tempNames (indivName varchar(30));
INSERT INTO tempNames
VALUES ("Carlos"), ("María"), ("José"), ("Ana"), ("Juan"), ("Gabriela"), ("Luis"), ("Fernanda"), ("Miguel"), ("Valeria"),
("Antonio"), ("Camila"), ("Fernando"), ("Daniela"), ("Javier"), ("Lucía"), ("Ricardo"), ("Sofía"), ("Andrés"), ("Isabela"),
("Manuel"), ("Carla"), ("Hugo"), ("Elena"), ("Emilio"), ("Paula"), ("Raúl"), ("Beatriz"), ("Diego"), ("Patricia"),
("Santiago"), ("Adriana"), ("Ángel"), ("Rocío"), ("Martín"), ("Verónica"), ("Pablo"), ("Cecilia"), ("Héctor"), ("Lorena"),
("Esteban"), ("Clara"), ("Rubén"), ("Alejandra"), ("Sebastián"), ("Mónica"), ("Gustavo"), ("Julieta"), ("Ramón"), ("Ximena");
```

### Consultas





### Estudiantes
- Victor Andrés Fung Chiong
- Giovanni Esquivel Cortés
  
 ### IC 4301 - Bases de Datos I
