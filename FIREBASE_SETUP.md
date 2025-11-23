# 🔥 Configuração do Firebase

Este guia explica como configurar o Firebase no projeto Turi.

## 📋 Pré-requisitos

1. Conta no [Firebase Console](https://console.firebase.google.com/)
2. Projeto criado no Firebase
3. App iOS registrado no Firebase

## 🚀 Passo a Passo

### 1. Adicionar GoogleService-Info.plist

1. Acesse o [Firebase Console](https://console.firebase.google.com/)
2. Selecione seu projeto
3. Vá em **Project Settings** (ícone de engrenagem)
4. Na aba **General**, encontre seu app iOS
5. Baixe o arquivo `GoogleService-Info.plist`
6. **Arraste o arquivo para a pasta `Turi/` no Xcode**
7. Certifique-se de que o arquivo está marcado para ser incluído no target "Turi"

### 2. Adicionar Dependências do Firebase via Swift Package Manager

1. No Xcode, vá em **File > Add Package Dependencies...**
2. Cole a URL: `https://github.com/firebase/firebase-ios-sdk`
3. Selecione as seguintes bibliotecas:
   - ✅ **FirebaseAuth** (Autenticação)
   - ✅ **FirebaseFirestore** (Banco de dados)
   - ✅ **FirebaseCore** (Core do Firebase)

### 3. Configurar URL Scheme para Google Sign-In (Opcional)

Se você quiser usar login com Google:

1. No Firebase Console, vá em **Authentication > Sign-in method**
2. Habilite **Google** como método de login
3. No Xcode, abra `Info.plist`
4. Adicione uma nova entrada:
   - **Key**: `CFBundleURLTypes`
   - **Type**: Array
   - Adicione um item com:
     - **Key**: `CFBundleURLSchemes`
     - **Type**: Array
     - **Value**: Seu `REVERSED_CLIENT_ID` do `GoogleService-Info.plist`

### 4. Configurar Firestore (Banco de Dados)

1. No Firebase Console, vá em **Firestore Database**
2. Clique em **Create Database**
3. Escolha **Start in test mode** (para desenvolvimento)
4. Selecione a localização do servidor
5. Clique em **Enable**

### 5. Regras de Segurança do Firestore

Para desenvolvimento, você pode usar estas regras básicas:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

**⚠️ IMPORTANTE**: Estas regras são apenas para desenvolvimento. Para produção, ajuste as regras conforme necessário.

## ✅ Verificação

Após configurar, o app deve:

1. ✅ Inicializar o Firebase automaticamente ao iniciar
2. ✅ Permitir cadastro de novos usuários
3. ✅ Permitir login com email e senha
4. ✅ Salvar dados do usuário no Firestore
5. ✅ Manter o usuário logado entre sessões

## 🐛 Troubleshooting

### Erro: "GoogleService-Info.plist não encontrado"
- Verifique se o arquivo está na pasta `Turi/`
- Verifique se o arquivo está incluído no target "Turi"

### Erro: "Firebase não configurado"
- Verifique se as dependências do Firebase foram adicionadas corretamente
- Limpe o build folder (Cmd + Shift + K) e compile novamente

### Erro de autenticação
- Verifique se o método de login está habilitado no Firebase Console
- Verifique se as regras do Firestore permitem escrita

## 📚 Recursos

- [Documentação do Firebase iOS](https://firebase.google.com/docs/ios/setup)
- [Firebase Authentication](https://firebase.google.com/docs/auth)
- [Cloud Firestore](https://firebase.google.com/docs/firestore)

