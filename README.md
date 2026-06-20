# Simulación de Pasarela de Pago con Flutter y Firebase

## Descripción

Aplicación móvil desarrollada en Flutter que simula una pasarela de pagos. El sistema permite ingresar información de pago, validar los datos ingresados y almacenar la información necesaria en Firebase Firestore.

La aplicación cumple con los siguientes requisitos:

* Nombre del titular obligatorio.
* Número de tarjeta obligatorio.
* Número de tarjeta con mínimo 16 dígitos.
* Fecha de expiración obligatoria.
* CVV obligatorio de 3 dígitos.
* No almacenar el número completo de la tarjeta.
* No almacenar el CVV.
* Guardar producto, total, últimos 4 dígitos, estado y fecha del pago.

---

## Tecnologías utilizadas

* Flutter
* Dart
* Firebase Core
* Cloud Firestore

---

## Estructura de almacenamiento

La aplicación guarda los pagos en la colección:

```text
pagos_simulados
```

Ejemplo de documento almacenado:

```json
{
  "producto": "Audífonos Bluetooth",
  "total": 25,
  "titular": "Juan Pérez",
  "ultimos4": "1234",
  "estado": "Completado",
  "fecha": "Timestamp"
}
```

---

## Capturas de la Aplicación

### Pantalla Principal

> Insertar captura aquí

![Pantalla Principal](images/app_01.png)

---

### Formulario Completo

> Insertar captura aquí

![Formulario](images/app_02.png)

---

### Validaciones del Formulario

> Insertar captura aquí

![Validaciones](images/app_03.png)

---



---

## Capturas de Firebase

### Colección `pagos_simulados`

> Insertar captura aquí

![Colección Firestore](images/firebase_01.png)

---


## Reglas de Firestore utilizadas

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

> Nota: Estas reglas fueron utilizadas únicamente para pruebas y desarrollo.

---

## Instalación

### 1. Clonar el repositorio

```bash
git clone URL_DEL_REPOSITORIO
```

### 2. Ingresar al proyecto

```bash
cd nombre_del_proyecto
```

### 3. Instalar dependencias

```bash
flutter pub get
```

### 4. Ejecutar la aplicación

```bash
flutter run
```

---

## Dependencias utilizadas

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^latest
  cloud_firestore: ^latest
```

---
### Link del APK
https://epnecuador-my.sharepoint.com/:f:/g/personal/edison_escobar01_epn_edu_ec/IgCfn661amYJTYoSjzwMar8EAVFz4CzKi-5cEnkQAULckpc?e=DPyd69
---

## Autor

Gabriel Escobar

Proyecto académico desarrollado con Flutter y Firebase Firestore.
