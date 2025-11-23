# 🔑 Configuração de APIs - Turi App

Este guia explica como configurar as APIs externas usadas no app.

## 📋 APIs Necessárias

### 1. **OpenAI API (ChatGPT)** 🔴 Obrigatório para ChatView

### 2. **API de Passagens Aéreas** 🟡 Opcional (usa dados mockados se não configurada)

---

## 🤖 OpenAI API (ChatGPT)

### **Passo 1: Obter API Key**

1. Acesse [OpenAI Platform](https://platform.openai.com/)
2. Crie uma conta ou faça login
3. Vá em **API Keys** no menu lateral
4. Clique em **Create new secret key**
5. Copie a chave (ela só aparece uma vez!)

### **Passo 2: Configurar no App**

#### **Opção A: Usar Config.plist (Recomendado)**

1. Copie o arquivo `Config.plist.example` para `Config.plist`
2. Abra `Config.plist` no Xcode
3. Substitua `sk-sua-chave-api-openai-aqui` pela sua chave real
4. **IMPORTANTE**: Adicione `Config.plist` ao `.gitignore` para não commitar a chave!

#### **Opção B: Variável de Ambiente**

1. No Xcode, vá em **Product > Scheme > Edit Scheme...**
2. Selecione **Run** > **Arguments**
3. Adicione uma variável de ambiente:
   - **Name**: `OPENAI_API_KEY`
   - **Value**: `sua-chave-aqui`

### **Passo 3: Verificar**

- Compile e execute o app
- Vá na aba **Chat**
- Envie uma mensagem
- Se funcionar, você verá a resposta do ChatGPT!

---

## ✈️ API de Passagens Aéreas (Amadeus)

### **Configuração da Amadeus API**

1. Acesse [Amadeus for Developers](https://developers.amadeus.com/)
2. Crie uma conta e faça login
3. Crie um novo app no dashboard
4. Obtenha seu **Client ID** e **Client Secret**

### **Configuração no App**

1. Adicione as credenciais no `Config.plist`:
   ```xml
   <key>AmadeusClientID</key>
   <string>seu-client-id-aqui</string>
   <key>AmadeusClientSecret</key>
   <string>seu-client-secret-aqui</string>
   ```

2. Ou use variáveis de ambiente:
   - `AMADEUS_CLIENT_ID`
   - `AMADEUS_CLIENT_SECRET`

**Guia completo:** Ver `AMADEUS_SETUP.md`

### **Nota sobre Dados Mockados**

Se não configurar a Amadeus, o app usará dados de exemplo automaticamente para desenvolvimento.

---

## 🔒 Segurança

### **⚠️ IMPORTANTE: Nunca commite suas API Keys!**

1. Adicione `Config.plist` ao `.gitignore`:
   ```
   # API Keys
   Config.plist
   ```

2. Use `Config.plist.example` como template (sem chaves reais)

3. Para produção, considere:
   - Usar um backend para gerenciar as chaves
   - Usar Keychain do iOS
   - Usar variáveis de ambiente no CI/CD

---

## 📝 Estrutura do Config.plist

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>OpenAIAPIKey</key>
	<string>sk-...</string>
	<key>FlightAPIKey</key>
	<string>...</string>
	<key>FlightAPIBaseURL</key>
	<string>https://api.amadeus.com/v2</string>
</dict>
</plist>
```

---

## 🧪 Testando

### **ChatView**
1. Abra o app
2. Vá na aba **Chat**
3. Digite uma mensagem (ex: "Onde comer pizza em São Paulo?")
4. Envie
5. Aguarde a resposta do ChatGPT

### **PassagemView**
1. Abra o app
2. Vá na aba **Buscar**
3. Preencha origem e destino
4. Selecione datas
5. Clique em "Buscar Passagens"
6. Veja os resultados (mockados ou reais, dependendo da configuração)

---

## 💰 Custos

### **OpenAI API**
- **Modelo usado**: `gpt-3.5-turbo`
- **Custo**: ~$0.002 por 1K tokens
- **Limite gratuito**: $5 de crédito inicial
- **Recomendação**: Configure limites de uso no dashboard da OpenAI

### **Amadeus API**
- **Plano gratuito**: Limitado (verifique no site)
- **Planos pagos**: Variam conforme uso

---

## 🐛 Troubleshooting

### **Erro: "API Key do OpenAI não configurada"**
- Verifique se `Config.plist` existe e está no projeto
- Verifique se a chave está correta
- Verifique se o arquivo está incluído no target

### **Erro: "Erro ao comunicar com a API"**
- Verifique sua conexão com internet
- Verifique se a API key está válida
- Verifique se há créditos na conta OpenAI

### **Passagens não aparecem**
- Se não configurou API, dados mockados aparecerão automaticamente
- Se configurou API, verifique as chaves e a URL base

---

## 📚 Recursos

- [OpenAI API Documentation](https://platform.openai.com/docs)
- [Amadeus API Documentation](https://developers.amadeus.com/)
- [Skyscanner API Documentation](https://developers.skyscanner.net/)

