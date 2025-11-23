# ✈️ Configuração da API Amadeus - Turi App

Este guia explica como configurar a API da Amadeus para busca de passagens aéreas.

## 📋 Pré-requisitos

1. Conta no [Amadeus for Developers](https://developers.amadeus.com/)
2. App criado no dashboard da Amadeus
3. Client ID e Client Secret obtidos

---

## 🚀 Passo a Passo

### **1. Criar Conta na Amadeus**

1. Acesse [Amadeus for Developers](https://developers.amadeus.com/)
2. Clique em **Sign Up** ou **Get Started**
3. Preencha seus dados e crie a conta
4. Confirme seu email

### **2. Criar um App**

1. Após fazer login, vá em **My Self-Service Workspace**
2. Clique em **Create New App**
3. Preencha:
   - **App Name**: Turi (ou outro nome)
   - **Description**: App de busca de passagens aéreas
   - **Category**: Travel
4. Clique em **Create**

### **3. Obter Credenciais**

Após criar o app, você verá:
- **API Key** (Client ID)
- **API Secret** (Client Secret)

**⚠️ IMPORTANTE**: Anote essas credenciais! Elas são necessárias para autenticação.

### **4. Configurar no App**

#### **Opção A: Usar Config.plist (Recomendado)**

1. Copie o arquivo `Config.plist.example` para `Config.plist`
2. Abra `Config.plist` no Xcode
3. Substitua os valores:
   ```xml
   <key>AmadeusClientID</key>
   <string>SEU_CLIENT_ID_AQUI</string>
   <key>AmadeusClientSecret</key>
   <string>SEU_CLIENT_SECRET_AQUI</string>
   ```
4. **IMPORTANTE**: Adicione `Config.plist` ao `.gitignore`

#### **Opção B: Variáveis de Ambiente**

1. No Xcode, vá em **Product > Scheme > Edit Scheme...**
2. Selecione **Run** > **Arguments**
3. Adicione variáveis de ambiente:
   - **Name**: `AMADEUS_CLIENT_ID` | **Value**: `seu-client-id`
   - **Name**: `AMADEUS_CLIENT_SECRET` | **Value**: `seu-client-secret`

---

## 🔐 Como Funciona a Autenticação

A Amadeus usa **OAuth 2.0** com client credentials:

1. App envia Client ID e Client Secret
2. Amadeus retorna um Access Token
3. Token é usado nas requisições de busca
4. Token expira após um tempo (renovado automaticamente)

**O serviço `AmadeusService` gerencia isso automaticamente!**

---

## 📝 Estrutura do Config.plist

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>OpenAIAPIKey</key>
	<string>sk-...</string>
	<key>AmadeusClientID</key>
	<string>seu-client-id-aqui</string>
	<key>AmadeusClientSecret</key>
	<string>seu-client-secret-aqui</string>
</dict>
</plist>
```

---

## 🧪 Testando

### **1. Verificar Configuração**

1. Compile o app
2. Abra a aba **Buscar**
3. Preencha origem e destino
4. Clique em "Buscar Passagens"

### **2. Resultados Esperados**

- ✅ **Se configurado corretamente**: Voos reais da Amadeus
- ⚠️ **Se não configurado**: Dados mockados (para desenvolvimento)

### **3. Códigos de Aeroporto (IATA)**

Use códigos IATA de 3 letras:
- **GRU** - São Paulo/Guarulhos
- **GIG** - Rio de Janeiro/Galeão
- **SSA** - Salvador
- **FOR** - Fortaleza
- **REC** - Recife
- **BSB** - Brasília

**Lista completa**: [IATA Codes](https://www.iata.org/en/publications/directories/code-search/)

---

## 💰 Planos e Limites

### **Plano Test (Gratuito)**
- ✅ 2.000 requisições/mês
- ✅ Acesso a APIs de teste
- ✅ Perfeito para desenvolvimento

### **Plano Self-Service (Pago)**
- ✅ Requisições ilimitadas
- ✅ Dados de produção
- ✅ Suporte prioritário

**Para desenvolvimento, o plano Test é suficiente!**

---

## 🐛 Troubleshooting

### **Erro: "Credenciais da Amadeus não configuradas"**
- ✅ Verifique se `Config.plist` existe
- ✅ Verifique se as chaves estão corretas
- ✅ Verifique se o arquivo está incluído no target

### **Erro: "Erro ao autenticar na Amadeus"**
- ✅ Verifique se Client ID e Secret estão corretos
- ✅ Verifique sua conexão com internet
- ✅ Verifique se sua conta está ativa

### **Erro: "Nenhum voo encontrado"**
- ✅ Verifique se os códigos IATA estão corretos
- ✅ Verifique se as datas são futuras
- ✅ Tente outros aeroportos/datas

### **Dados Mockados Aparecem**
- ✅ Isso é normal se as credenciais não estiverem configuradas
- ✅ Configure as credenciais para usar dados reais
- ✅ Dados mockados são úteis para desenvolvimento

---

## 📚 Recursos

- [Amadeus for Developers](https://developers.amadeus.com/)
- [Flight Offers Search API](https://developers.amadeus.com/self-service/category/air/api-doc/flight-offers-search)
- [Authentication Guide](https://developers.amadeus.com/get-started/amadeus-for-developers/security-262)
- [API Reference](https://developers.amadeus.com/self-service)

---

## ✅ Checklist

- [ ] Conta criada na Amadeus
- [ ] App criado no dashboard
- [ ] Client ID e Secret obtidos
- [ ] `Config.plist` criado e configurado
- [ ] `Config.plist` adicionado ao `.gitignore`
- [ ] App testado com busca de voos
- [ ] Resultados aparecendo corretamente

---

## 🎯 Próximos Passos

1. **Configure as credenciais** seguindo este guia
2. **Teste a busca** com diferentes origens/destinos
3. **Verifique os resultados** (preços, horários, escalas)
4. **Ajuste a UI** conforme necessário

---

**Tudo pronto!** 🚀 Configure e teste a busca de passagens!

