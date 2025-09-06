# Use a imagem oficial do RabbitMQ com management plugin
FROM rabbitmq:3.12-management

# Define variáveis de ambiente (podem ser sobrescritas via --env-file)
ENV RABBITMQ_DEFAULT_USER=admin
ENV RABBITMQ_DEFAULT_PASS=admin123
ENV RABBITMQ_DEFAULT_VHOST=/
ENV RABBITMQ_ERLANG_COOKIE=SWQOKODSQALRPCLNMEQG
ENV RABBITMQ_AMQP_PORT=5672
ENV RABBITMQ_MANAGEMENT_PORT=15672
ENV RABBITMQ_CLUSTERING_PORT=25672
ENV RABBITMQ_DISK_FREE_LIMIT=1GB
ENV RABBITMQ_MEMORY_HIGH_WATERMARK=0.6
ENV RABBITMQ_LOG_LEVEL_CONNECTION=error
ENV RABBITMQ_LOG_LEVEL_DEFAULT=info
ENV RABBITMQ_SERVER_ADDITIONAL_ERL_ARGS="-rabbit log_levels [{connection,error},{default,info}]"

# Instala dependências adicionais se necessário
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Cria diretórios necessários
RUN mkdir -p /var/lib/rabbitmq/mnesia \
    && chown -R rabbitmq:rabbitmq /var/lib/rabbitmq

# Configura o RabbitMQ usando variáveis de ambiente
RUN echo "default_user = ${RABBITMQ_DEFAULT_USER}" > /etc/rabbitmq/rabbitmq.conf \
    && echo "default_pass = ${RABBITMQ_DEFAULT_PASS}" >> /etc/rabbitmq/rabbitmq.conf \
    && echo "default_vhost = ${RABBITMQ_DEFAULT_VHOST}" >> /etc/rabbitmq/rabbitmq.conf \
    && echo "listeners.tcp.default = ${RABBITMQ_AMQP_PORT}" >> /etc/rabbitmq/rabbitmq.conf \
    && echo "management.tcp.port = ${RABBITMQ_MANAGEMENT_PORT}" >> /etc/rabbitmq/rabbitmq.conf \
    && echo "management.tcp.ip = 0.0.0.0" >> /etc/rabbitmq/rabbitmq.conf \
    && echo "disk_free_limit.absolute = ${RABBITMQ_DISK_FREE_LIMIT}" >> /etc/rabbitmq/rabbitmq.conf \
    && echo "vm_memory_high_watermark.relative = ${RABBITMQ_MEMORY_HIGH_WATERMARK}" >> /etc/rabbitmq/rabbitmq.conf

# Expõe as portas necessárias usando variáveis de ambiente
# ${RABBITMQ_AMQP_PORT}: porta AMQP padrão
# ${RABBITMQ_MANAGEMENT_PORT}: porta do management plugin
# ${RABBITMQ_CLUSTERING_PORT}: porta para clustering
EXPOSE ${RABBITMQ_AMQP_PORT} ${RABBITMQ_MANAGEMENT_PORT} ${RABBITMQ_CLUSTERING_PORT}

# Cria diretório para dados persistentes
VOLUME ["/var/lib/rabbitmq"]

# Define o usuário não-root para segurança
USER rabbitmq

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD rabbitmq-diagnostics ping || exit 1

# Comando de inicialização
CMD ["rabbitmq-server"]
