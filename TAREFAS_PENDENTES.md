# 📋 Tarefas Pendentes - Turi App

## ✅ O que já está pronto

- ✅ **Firebase**: Estrutura completa (Auth, Firestore)
- ✅ **ChatGPT**: Integração completa
- ✅ **Amadeus**: Integração completa
- ✅ **Autenticação**: Login/Cadastro com email e senha
- ✅ **Validações**: Todos os campos validados
- ✅ **ChatView**: Funcional com ChatGPT
- ✅ **PassagemView**: Funcional com Amadeus
- ✅ **MapsView**: Funcional (já existia)

---

## 🔴 PRIORIDADE ALTA (Obrigatório)

### 1. **Implementar Logout no SettingsView** ⚠️

**Status:** Botão existe mas não funciona

**O que fazer:**
- [ ] Conectar `SettingsView` com `AuthService`
- [ ] Carregar dados do usuário logado (nome, email)
- [ ] Implementar função de logout
- [ ] Atualizar UI para mostrar dados reais
- [ ] Adicionar loading states

**Arquivos a modificar:**
- `View/SettingsView.swift`

**Tempo estimado:** 30-45 minutos

---

### 2. **Integrar Viagens com Firestore** ⚠️

**Status:** Atualmente usando UserDefaults (apenas local)

**Problema:** 
- Viagens não sincronizam entre dispositivos
- Dados podem ser perdidos se desinstalar app

**O que fazer:**
- [ ] Criar `Service/TripService.swift` para gerenciar viagens no Firestore
- [ ] Migrar `ViagemViewModel` para usar Firestore
- [ ] Manter backup local (UserDefaults) como fallback
- [ ] Sincronizar viagens entre dispositivos
- [ ] Adicionar tratamento de erros offline

**Estrutura Firestore:**
```
users/{userId}/trips/{tripId}
  - id: UUID
  - nome: String
  - data: Timestamp
  - notas: String?
  - createdAt: Timestamp
```

**Arquivos a criar/modificar:**
- `Service/TripService.swift` (novo)
- `ViewModel/ViagemViewModel.swift` (atualizar)

**Tempo estimado:** 1-2 horas

---

### 3. **Melhorar SettingsView** ⚠️

**Status:** Interface básica, falta funcionalidades

**O que fazer:**
- [ ] Mostrar dados do usuário logado (nome, email)
- [ ] Permitir editar nome
- [ ] Permitir editar email (com validação)
- [ ] Adicionar opção de trocar senha
- [ ] Adicionar opção de excluir conta
- [ ] Mostrar foto de perfil (se tiver)
- [ ] Adicionar seção de informações da conta
- [ ] Melhorar layout e UX

**Arquivos a modificar:**
- `View/SettingsView.swift`
- `Service/AuthService.swift` (adicionar métodos de atualização)

**Tempo estimado:** 1-2 horas

---

## 🟡 PRIORIDADE MÉDIA (Melhorias importantes)

### 4. **Implementar Login com Google** ⚠️

**Status:** Estrutura pronta no `AuthService`, falta implementação

**O que fazer:**
- [ ] Adicionar GoogleSignIn SDK via SPM
- [ ] Configurar URL Scheme no `Info.plist`
- [ ] Implementar botão de login Google na `LoginView`
- [ ] Testar fluxo completo
- [ ] Tratar erros específicos

**Arquivos a modificar:**
- `View/LoginView.swift`
- `Service/AuthService.swift` (já tem método `signInWithGoogle`)

**Tempo estimado:** 1-2 horas

---

### 5. **Implementar Login com Apple** ⚠️

**Status:** Não implementado

**O que fazer:**
- [ ] Configurar Sign in with Apple no Firebase Console
- [ ] Implementar autenticação Apple no `AuthService`
- [ ] Adicionar botão na `LoginView`
- [ ] Testar fluxo completo
- [ ] Tratar erros específicos

**Arquivos a criar/modificar:**
- `Service/AuthService.swift` (adicionar método)
- `View/LoginView.swift`

**Tempo estimado:** 1-2 horas

---

### 6. **Melhorar tratamento de erros** ⚠️

**Status:** Básico implementado, pode melhorar

**O que fazer:**
- [ ] Adicionar tratamento de erros offline
- [ ] Melhorar mensagens de erro em todas as telas
- [ ] Adicionar retry automático para requisições
- [ ] Adicionar indicadores de loading consistentes
- [ ] Tratar erros de rede especificamente

**Tempo estimado:** 1-2 horas

---

## 🟢 PRIORIDADE BAIXA (Funcionalidades extras)

### 7. **Melhorar HomeView** ⚠️

**Status:** Funcional, mas pode ter melhorias

**O que fazer:**
- [ ] Verificar se carrossel está funcionando bem
- [ ] Adicionar pull-to-refresh
- [ ] Melhorar animações
- [ ] Adicionar tratamento de erros
- [ ] Otimizar performance

**Tempo estimado:** 1 hora

---

### 8. **Melhorar MapsView** ⚠️

**Status:** Funcional, mas pode ter melhorias

**O que fazer:**
- [ ] Verificar se rota está sendo traçada corretamente
- [ ] Melhorar UI dos pins
- [ ] Adicionar mais informações nos cards
- [ ] Otimizar busca de lugares
- [ ] Adicionar filtros

**Tempo estimado:** 1-2 horas

---

### 9. **Adicionar testes** ⚠️

**Status:** Não implementado

**O que fazer:**
- [ ] Criar testes unitários para ViewModels
- [ ] Criar testes para serviços (AuthService, AmadeusService, etc.)
- [ ] Criar testes de integração
- [ ] Adicionar testes de UI (opcional)

**Tempo estimado:** 2-4 horas

---

### 10. **Otimizações e melhorias gerais** ⚠️

**O que fazer:**
- [ ] Revisar código e remover duplicações
- [ ] Adicionar documentação no código
- [ ] Melhorar acessibilidade
- [ ] Otimizar imagens e assets
- [ ] Adicionar analytics (opcional)
- [ ] Melhorar performance geral

**Tempo estimado:** Variável

---

## 📊 Resumo por Prioridade

### 🔴 **Alta (Obrigatório)**
1. Logout no SettingsView
2. Viagens no Firestore
3. Melhorar SettingsView

**Tempo total estimado:** 3-4 horas

### 🟡 **Média (Importante)**
4. Login com Google
5. Login com Apple
6. Melhorar tratamento de erros

**Tempo total estimado:** 4-6 horas

### 🟢 **Baixa (Extras)**
7. Melhorar HomeView
8. Melhorar MapsView
9. Adicionar testes
10. Otimizações gerais

**Tempo total estimado:** 5-8 horas

---

## 🎯 Plano de Ação Recomendado

### **Semana 1: Funcionalidades Essenciais**
1. ✅ **Dia 1:** Implementar Logout no SettingsView
2. ✅ **Dia 2:** Integrar Viagens com Firestore
3. ✅ **Dia 3:** Melhorar SettingsView
4. ✅ **Dia 4:** Testar e corrigir bugs

### **Semana 2: Melhorias**
5. ✅ **Dia 1:** Login com Google
6. ✅ **Dia 2:** Login com Apple
7. ✅ **Dia 3:** Melhorar tratamento de erros
8. ✅ **Dia 4:** Testes e ajustes

### **Semana 3: Polimento**
9. ✅ **Dia 1-2:** Melhorias gerais
10. ✅ **Dia 3:** Otimizações
11. ✅ **Dia 4:** Testes finais

---

## 📝 Checklist Rápido

### **Para o app estar completo:**
- [ ] Logout funcionando
- [ ] Viagens sincronizadas no Firestore
- [ ] SettingsView mostrando dados do usuário
- [ ] Edição de perfil funcionando
- [ ] Login com Google (opcional)
- [ ] Login com Apple (opcional)
- [ ] Tratamento de erros robusto

---

## 🚨 Problemas Conhecidos

1. **SettingsView não conectado**
   - Não mostra dados do usuário
   - Logout não funciona
   - Campos não são editáveis

2. **Viagens apenas locais**
   - Não sincroniza entre dispositivos
   - Pode perder dados

3. **Login social não implementado**
   - Google: estrutura pronta, falta SDK
   - Apple: não implementado

---

## 💡 Dicas

1. **Comece pelo SettingsView** - É rápido e importante
2. **Depois integre Viagens** - Melhora muito a experiência
3. **Teste cada funcionalidade** antes de passar para a próxima
4. **Use o console do Firebase** para verificar dados
5. **Mantenha backups** durante desenvolvimento

---

## 📚 Recursos Úteis

- `FIREBASE_SETUP.md` - Configuração Firebase
- `AMADEUS_SETUP.md` - Configuração Amadeus
- `API_SETUP.md` - Configuração APIs
- `IMPLEMENTACAO.md` - O que foi implementado
- `INTEGRACOES_API.md` - Integrações de API

---

## ✅ Status Atual

### **Completo:**
- ✅ Autenticação básica (email/senha)
- ✅ Integração ChatGPT
- ✅ Integração Amadeus
- ✅ Validações
- ✅ ChatView
- ✅ PassagemView
- ✅ MapsView

### **Pendente:**
- ⚠️ Logout
- ⚠️ Viagens no Firestore
- ⚠️ SettingsView completo
- ⚠️ Login social
- ⚠️ Melhorias gerais

---

**Foco nas prioridades altas primeiro!** 🚀

