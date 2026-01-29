# 🔧 Guide de dépannage PayPal

## 🚨 **Problèmes identifiés et solutions**

### **1. Erreur de connexion PayPal**

#### **Causes possibles :**
- ❌ Backend non accessible à l'URL `http://192.168.100.76:5000/api`
- ❌ Endpoint PayPal non configuré
- ❌ Token d'authentification invalide
- ❌ Problème de réseau

#### **Solutions :**

**A. Vérifier la connectivité backend :**
```bash
# Testez l'URL dans votre navigateur ou Postman
curl http://192.168.100.76:5000/api/health
```

**B. Vérifier que le backend est démarré :**
```bash
# Dans le dossier BACKEND
cd BACKEND/Smpnt.Inma
dotnet run
```

**C. Vérifier l'URL dans le code mobile :**
```dart
// Dans paypal_service.dart
static const String baseUrl = 'http://192.168.100.76:5000/api';
```

### **2. Overflow de layout dans VehicleCardComponent**

#### **Solution appliquée :**
```dart
// Ajout de mainAxisSize: MainAxisSize.min
child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min, // ✅ Ajouté
  children: [
    // ... contenu
  ],
),
```

## 🧪 **Tests de diagnostic**

### **Test 1: Connectivité backend**
```dart
// Le code mobile teste maintenant automatiquement :
final isBackendConnected = await BackendTestService.testConnection();
```

### **Test 2: Endpoint PayPal**
```dart
// Test spécifique de l'endpoint PayPal :
final isPayPalEndpointWorking = await BackendTestService.testPayPalEndpoint(authToken);
```

### **Test 3: Logs détaillés**
Les logs suivants apparaîtront dans la console :
```
🔗 Tentative de connexion à: http://192.168.100.76:5000/api/payments/paypal/create
💰 Montant: 100.0 USD
🔑 Token: eyJhbGciOi...
📡 Status Code: 200
📄 Response Body: {"success":true,"paymentId":"PAYID-..."}
```

## 🔍 **Diagnostic étape par étape**

### **Étape 1: Vérifier le backend**
1. Ouvrez un terminal dans le dossier `BACKEND/Smpnt.Inma`
2. Exécutez `dotnet run`
3. Vérifiez que le serveur démarre sur le port 5000
4. Testez l'URL : `http://192.168.100.76:5000/api/health`

### **Étape 2: Vérifier l'authentification**
1. Assurez-vous que l'utilisateur est connecté
2. Vérifiez que le token JWT est valide
3. Testez un autre endpoint qui nécessite l'authentification

### **Étape 3: Vérifier PayPal**
1. Vérifiez que le service PayPal est enregistré dans `Program.cs`
2. Vérifiez la configuration PayPal dans `appsettings.json`
3. Testez l'endpoint : `POST /api/payments/paypal/create`

## 🛠️ **Configuration requise**

### **Backend (appsettings.json)**
```json
{
  "PayPalSettings": {
    "ClientId": "VOTRE_CLIENT_ID",
    "ClientSecret": "VOTRE_CLIENT_SECRET",
    "BaseUrl": "https://api.sandbox.paypal.com",
    "WebhookId": "VOTRE_WEBHOOK_ID",
    "IsSandbox": "true",
    "WebhookUrl": "http://192.168.100.76:5000/api/payments/paypal/webhook"
  }
}
```

### **Mobile (paypal_service.dart)**
```dart
static const String baseUrl = 'http://192.168.100.76:5000/api';
```

## 📱 **Tests sur l'application mobile**

### **Test 1: Interface utilisateur**
1. Ouvrir l'écran de paiement
2. Sélectionner PayPal
3. Vérifier l'affichage du formulaire PayPal
4. Cliquer sur "Payer maintenant"

### **Test 2: Logs de diagnostic**
Regardez la console pour ces messages :
- ✅ `🔍 Test de connectivité backend...`
- ✅ `🔍 Test de l'endpoint PayPal...`
- ✅ `🔗 Tentative de connexion à: ...`
- ✅ `📡 Status Code: 200`

### **Test 3: Gestion d'erreurs**
Si une erreur survient, vous verrez :
- ❌ `Backend non accessible`
- ❌ `Endpoint PayPal non accessible`
- ❌ `Erreur HTTP 404/500`

## 🚀 **Solutions rapides**

### **Si le backend n'est pas accessible :**
1. Vérifiez que l'IP `192.168.100.76` est correcte
2. Vérifiez que le port `5000` est ouvert
3. Vérifiez que le backend est démarré

### **Si l'endpoint PayPal n'existe pas :**
1. Vérifiez que `PayPalController` est enregistré
2. Vérifiez que la route `/api/payments/paypal/create` existe
3. Vérifiez que le service PayPal est configuré

### **Si l'authentification échoue :**
1. Vérifiez que l'utilisateur est connecté
2. Vérifiez que le token JWT est valide
3. Vérifiez que l'en-tête Authorization est correct

## 📊 **Codes d'erreur courants**

| Code | Signification | Solution |
|------|---------------|----------|
| 404 | Endpoint non trouvé | Vérifier la route dans le backend |
| 401 | Non autorisé | Vérifier le token d'authentification |
| 500 | Erreur serveur | Vérifier les logs du backend |
| Timeout | Connexion lente | Vérifier la connectivité réseau |

## ✅ **Checklist de validation**

- [ ] Backend démarré et accessible
- [ ] URL backend correcte dans le mobile
- [ ] Service PayPal configuré
- [ ] Token d'authentification valide
- [ ] Endpoint PayPal fonctionnel
- [ ] Interface utilisateur sans overflow
- [ ] Logs de diagnostic visibles
- [ ] Gestion d'erreurs implémentée
