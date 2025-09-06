# Receba RabbitMQ

Este projeto contém um Dockerfile completo para executar o RabbitMQ com interface de gerenciamento, incluindo toda a configuração necessária.

## Configuração

### Credenciais Padrão
- **Usuário**: admin
- **Senha**: admin123
- **Virtual Host**: /

### Portas
- **5672**: Porta AMQP (para conexões de aplicação)
- **15672**: Interface de gerenciamento web
- **25672**: Porta para clustering

## Configuração de Ambiente

### 1. Configurar variáveis de ambiente
```bash
# Copie o arquivo de exemplo
cp env.example rabbitmq.env

# Edite as configurações conforme necessário
nano rabbitmq.env
```

### 2. Construir e executar
```bash
# Construir a imagem
docker build -t receba-rabbitmq .

# Executar o container com arquivo de ambiente
docker run -d \
  --name receba-rabbitmq \
  --env-file rabbitmq.env \
  -p 5672:5672 \
  -p 15672:15672 \
  -p 25672:25672 \
  -v rabbitmq_data:/var/lib/rabbitmq \
  receba-rabbitmq
```

### 3. Executar sem arquivo de ambiente (usa valores padrão)
```bash
docker run -d \
  --name receba-rabbitmq \
  -p 5672:5672 \
  -p 15672:15672 \
  -p 25672:25672 \
  -v rabbitmq_data:/var/lib/rabbitmq \
  receba-rabbitmq
```

### Comandos úteis
```bash
# Ver logs do container
docker logs -f receba-rabbitmq

# Parar o container
docker stop receba-rabbitmq

# Remover o container
docker rm receba-rabbitmq

# Executar comandos dentro do container
docker exec -it receba-rabbitmq rabbitmq-diagnostics status
```

## Acesso à Interface de Gerenciamento

Após iniciar o container, acesse:
- **URL**: http://localhost:15672
- **Usuário**: admin
- **Senha**: admin123

## Características do Dockerfile

- **Configuração completa**: Todas as configurações estão no Dockerfile
- **Health check**: Verificação automática de saúde do serviço
- **Dados persistentes**: Volume para manter dados entre reinicializações
- **Segurança**: Executa com usuário não-root
- **Otimizado**: Configurações de memória e disco otimizadas
- **Logs configurados**: Níveis de log apropriados para produção
- **Variáveis de ambiente**: Configuração flexível via arquivo .env

## Segurança

### Arquivo de Ambiente
- **`rabbitmq.env`**: Contém dados sensíveis (usuário, senha, cookie)
- **`env.example`**: Template para outros desenvolvedores
- **`.dockerignore`**: Exclui arquivos de ambiente do build

### Boas Práticas
1. **Nunca commite** o arquivo `rabbitmq.env` no Git
2. **Use senhas fortes** em produção
3. **Altere o cookie Erlang** para ambientes de produção
4. **Monitore logs** para detectar tentativas de acesso

### Exemplo de Configuração Segura
```bash
# Para produção, use senhas complexas
RABBITMQ_DEFAULT_PASS=MinhaSenh@SuperSegura123!
RABBITMQ_ERLANG_COOKIE=COOKIE_ALEATORIO_PARA_PRODUCAO
```
