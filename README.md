# Tractian Seller

Assistente inteligente para vendas da Tractian. Um aplicativo Flutter que permite conversar com ChatGPT enviando imagens obrigatoriamente para iniciar a conversa, com geração de relatórios em PDF.

## Funcionalidades

- 🖼️ **Análise de Imagens**: Envie imagens obrigatoriamente para iniciar conversas
- 🤖 **Chat Inteligente**: Converse naturalmente com ChatGPT com contexto mantido
- 📄 **Relatórios PDF**: Gere relatórios completos das conversas
- 📱 **Interface Moderna**: Design limpo e responsivo

## Configuração

### 1. Pré-requisitos

- Flutter SDK (versão 3.6.0 ou superior)
- Dart SDK
- Chave da API OpenAI

### 2. Instalação

1. Clone o repositório:
```bash
git clone <url-do-repositorio>
cd hackathon
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Configure a chave da API OpenAI:
   - Edite o arquivo `.env` na raiz do projeto
   - Substitua `sua_chave_da_openai_aqui` pela sua chave real da OpenAI:
```env
OPENAI_API_KEY=sk-sua-chave-aqui
OPENAI_MODEL=gpt-4o
```

4. Execute o aplicativo:
```bash
flutter run
```

## Como Usar

### 1. Iniciar Chat

1. Na tela inicial, toque em "Iniciar Chat"
2. **Selecione uma imagem** (obrigatório):
   - Toque no ícone de imagem
   - Escolha entre galeria ou câmera
3. Toque em "Iniciar Conversa"
4. Digite um título e mensagem inicial
5. Comece a conversar!

### 2. Gerar Relatório

Durante ou após a conversa:
1. Toque no menu (⋮) no canto superior direito
2. Escolha "Ver Relatório" ou "Compartilhar Relatório"
3. O PDF será gerado automaticamente com:
   - Resumo da sessão
   - Regras aplicadas
   - Conversa completa
   - Indicadores de imagens compartilhadas

## Estrutura do Projeto

```
lib/
├── models/           # Modelos de dados
│   ├── message.dart
│   ├── chat_rule.dart
│   └── chat_session.dart
├── services/         # Serviços e lógica de negócio
│   ├── openai_service.dart
│   ├── pdf_service.dart
│   └── chat_provider.dart
├── screens/          # Telas da aplicação
│   └── chat_screen.dart
├── widgets/          # Widgets reutilizáveis
│   ├── message_bubble.dart
│   ├── chat_input.dart
│   └── image_preview.dart
└── main.dart         # Ponto de entrada da aplicação
```

## Dependências Principais

- `provider`: Gerenciamento de estado
- `http`: Requisições HTTP para OpenAI API
- `image_picker`: Seleção de imagens
- `pdf` & `printing`: Geração e visualização de PDFs
- `flutter_dotenv`: Gerenciamento de variáveis de ambiente
- `path_provider`: Acesso ao sistema de arquivos

## Configuração da API OpenAI

1. Crie uma conta em [OpenAI](https://platform.openai.com/)
2. Gere uma chave da API
3. Configure no arquivo `.env`:
   - `OPENAI_API_KEY`: Sua chave da API
   - `OPENAI_MODEL`: Modelo a ser usado (recomendado: `gpt-4o` para análise de imagens)

## Limitações

- Requer conexão com internet para funcionar
- Custos associados ao uso da API OpenAI
- Imagem obrigatória para iniciar conversas
- Sistema de análise guiado por regras internas da IA

## Solução de Problemas

### Erro de conexão com OpenAI
- Verifique se a chave da API está correta no arquivo `.env`
- Confirme que há créditos disponíveis na conta OpenAI
- Verifique a conexão com internet

### Erro ao selecionar imagens
- Verifique as permissões de câmera e galeria no dispositivo
- Certifique-se de que o dispositivo suporta seleção de imagens

### Erro na geração de PDF
- Verifique as permissões de armazenamento
- Certifique-se de que há espaço disponível no dispositivo

## Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-funcionalidade`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/nova-funcionalidade`)
5. Abra um Pull Request

## Licença

Este projeto está licenciado sob a licença MIT - veja o arquivo LICENSE para detalhes.
