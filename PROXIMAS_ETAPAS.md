# 🚀 Próximas Etapas - Turi App

## 📋 Prioridades

### 🔴 **PRIORIDADE ALTA (Obrigatório para funcionar)**

### 1. **Configurar Firebase** ⚠️
**Status:** Estrutura pronta, precisa configuração

**O que fazer:**
- [ ] Adicionar `GoogleService-Info.plist` ao projeto
- [ ] Adicionar dependências do Firebase via SPM:
  - FirebaseAuth
  - FirebaseFirestore
  - FirebaseCore
- [ ] Configurar Firestore Database no Firebase Console
- [ ] Testar login e cadastro

**Guia completo:** Ver `FIREBASE_SETUP.md`

**Tempo estimado:** 15-30 minutos

---

### 2. **Implementar Logout no SettingsView** ⚠️
**Status:** Botão existe mas não funciona

**O que fazer:**
- [ ] Conectar SettingsView com AuthService
- [ ] Implementar função de logout
- [ ] Carregar dados do usuário logado
- [ ] Permitir edição de perfil (opcional)

**Tempo estimado:** 30-45 minutos

---

### 🟡 **PRIORIDADE MÉDIA (Melhorias importantes)**

### 3. **Integrar Viagens com Firestore** ⚠️
**Status:** Atualmente usando UserDefaults (local)

**O que fazer:**
- [ ] Criar `TripService` para gerenciar viagens no Firestore
- [ ] Migrar `ViagemViewModel` para usar Firestore
- [ ] Sincronizar viagens entre dispositivos
- [ ] Manter backup local (UserDefaults) como fallback

**Tempo estimado:** 1-2 horas

---

### 4. **Melhorar SettingsView** ⚠️
**Status:** Interface básica, precisa funcionalidades

**O que fazer:**
- [ ] Mostrar dados do usuário logado
- [ ] Permitir editar nome e email
- [ ] Adicionar opção de trocar senha
- [ ] Adicionar opção de excluir conta
- [ ] Mostrar foto de perfil (se tiver)

**Tempo estimado:** 1-2 horas

---

### 🟢 **PRIORIDADE BAIXA (Funcionalidades extras)**

### 5. **Implementar Login com Google** ⚠️
**Status:** Estrutura pronta, precisa SDK

**O que fazer:**
- [ ] Adicionar GoogleSignIn SDK via SPM
- [ ] Configurar URL Scheme no Info.plist
- [ ] Implementar UI de login Google
- [ ] Testar fluxo completo

**Tempo estimado:** 1-2 horas

---

### 6. **Implementar Login com Apple** ⚠️
**Status:** Não implementado

**O que fazer:**
- [ ] Configurar Sign in with Apple no Firebase
- [ ] Implementar autenticação Apple
- [ ] Adicionar botão na LoginView
- [ ] Testar fluxo completo

**Tempo estimado:** 1-2 horas

---

### 7. **Melhorar outras telas** ⚠️
**Status:** Telas existem mas podem precisar melhorias

**O que fazer:**
- [ ] Verificar se ChatView precisa integração
- [ ] Verificar se PassagemView precisa melhorias
- [ ] Verificar se MapsView precisa melhorias
- [ ] Adicionar tratamento de erros em todas as telas

**Tempo estimado:** Variável

---

## 🎯 Plano de Ação Recomendado

### **Semana 1: Funcionalidades Básicas**
1. ✅ **Dia 1:** Configurar Firebase
2. ✅ **Dia 2:** Implementar Logout no SettingsView
3. ✅ **Dia 3:** Testar tudo e corrigir bugs

### **Semana 2: Integrações**
4. ✅ **Dia 1-2:** Integrar Viagens com Firestore
5. ✅ **Dia 3:** Melhorar SettingsView
6. ✅ **Dia 4:** Testar e corrigir

### **Semana 3: Funcionalidades Extras**
7. ✅ **Dia 1-2:** Login com Google
8. ✅ **Dia 3:** Login com Apple
9. ✅ **Dia 4:** Testes finais

---

## 📝 Checklist Rápido

### **Para o app funcionar:**
- [ ] Firebase configurado
- [ ] Login funcionando
- [ ] Cadastro funcionando
- [ ] Logout funcionando
- [ ] Persistência de sessão funcionando

### **Para melhorar o app:**
- [ ] Viagens sincronizadas no Firestore
- [ ] Perfil do usuário editável
- [ ] Login com Google
- [ ] Login com Apple

---

## 🚨 Problemas Conhecidos

1. **SettingsView não mostra dados do usuário**
   - Precisa conectar com AuthService
   - Precisa carregar dados do Firestore

2. **Viagens salvas apenas localmente**
   - Não sincroniza entre dispositivos
   - Pode perder dados se desinstalar app

3. **Login com Google/Apple não funciona**
   - Precisa configurar SDKs
   - Precisa configurar no Firebase Console

---

## 💡 Dicas

1. **Comece pelo Firebase** - É a base de tudo
2. **Teste cada funcionalidade** antes de passar para a próxima
3. **Use o console do Firebase** para verificar dados salvos
4. **Mantenha backups** durante desenvolvimento

---

## 📚 Recursos Úteis

- `FIREBASE_SETUP.md` - Guia de configuração do Firebase
- `IMPLEMENTACAO.md` - Documentação do que foi implementado
- [Firebase Documentation](https://firebase.google.com/docs)
- [Firebase iOS Setup](https://firebase.google.com/docs/ios/setup)

