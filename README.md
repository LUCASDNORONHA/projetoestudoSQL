
# Instruções para a Criação de um Projeto de Banco de Dados

Este documento apresenta um estudo de caso sobre a criação e a estruturação de um projeto de banco de dados utilizando o sistema gerenciador de banco de dados (SGBD) PostgreSQL. O trabalho também tem como finalidade aprofundar o conhecimento em SQL e em suas diferentes formas de utilização, aspectos que igualmente constituem objeto deste estudo.

O objetivo principal consiste em dominar o uso das ferramentas de banco de dados por meio da reprodução, com fins didáticos, de um projeto inspirado em um cenário real, ainda que simplificado.

# Introdução

Ao utilizar o DBeaver em conjunto com o PostgreSQL, é fundamental compreender que existem duas camadas distintas no processo de gerenciamento do banco de dados:

- O **servidor de banco de dados (PostgreSQL)**, responsável por armazenar e gerenciar efetivamente os dados.
- O **cliente gráfico (DBeaver)**, que atua apenas como uma interface para se conectar ao servidor e administrá-lo.

Mesmo quando ambos estão instalados no mesmo computador, essa separação conceitual permanece. O PostgreSQL executa como um servidor local, enquanto o DBeaver funciona como uma interface de controle para interação com esse servidor.

## Instalar e confirmar que o PostgreSQL está em execução

Foi dado preferência neste projeto, fazer tudo pelo terminal de linha de comando, visando que trabalhar diretamente pelo terminal força uma compreensão muito mais nítida do funcionamento do PostgreSQL. Interfaces gráficas como DBeaver são convenientes, mas o terminal revela a mecânica real do sistema. Embora utilizaremos também o Dbeaver para visualização da estrutura do banco de dados enquanto vai sendo criado.

Para trabalhar localmente com PostgreSQL, é necessário que o servidor esteja instalado e em execução na máquina. O sistema opera segundo uma arquitetura cliente–servidor.

Para instalar o PostgreSQL, execute a seguinte sequência de comandos no terminal:

```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
psql --version
````

Antes de qualquer operação com o banco de dados, é essencial confirmar que o servidor está ativo. No Kubuntu (sistema operacional utilizado neste estudo), o PostgreSQL normalmente é executado como um serviço do sistema. Após a instalação, o servidor costuma ser iniciado automaticamente. Ainda assim, recomenda-se verificar o seu estado.

No terminal, utilize o comando:

```bash
sudo systemctl status postgresql
```

Se o serviço estiver em execução, será exibida uma mensagem semelhante a:

```
active (running)
```

Caso o servidor não esteja ativo, ele pode ser iniciado manualmente com o comando:

```bash
sudo systemctl start postgresql
```
## Criar um banco de dados para estudos

Antes de estabelecer a conexão com o servidor, recomenda-se criar um banco de dados específico para experimentação.

Um exemplo de nome apropriado seria:

```
projeto_estudos
```


A partir desse ponto, haverá um ambiente próprio e isolado para realizar experimentos, estruturar tabelas e desenvolver o projeto de banco de dados ao longo deste estudo.

Primeiro, entre no ambiente do usuário administrativo do banco:

```
sudo -u postgres psql
```

Se tudo estiver correto, aparecerá algo semelhante a:

```
postgres=#
```

Esse é o prompt do PostgreSQL. Vamos criar um banco de dados para nosso projeto e não vamos mexer no banco de dados padrão postgres.

Digite:

```
CREATE DATABASE projeto_estudos;
```

Depois digite o seguinte comando para listar os bancos existentes:

```
\l 
```

Se o banco projeto_estudos aparecer, pode seguir para o seguinte passo. 

Agora execute o comando para definir a senha do usuário postgres:

```
ALTER USER postgres WITH PASSWORD 'sua_senha';
```

Depois saia do PostgreSQL:

```
\q
```

A partir desse momento, o servidor já possui uma senha registrada.

## Abrir o DBeaver e criar uma conexão

No DBeaver, o banco de dados não aparece automaticamente. É necessário criar uma conexão com o servidor PostgreSQL.

### Procedimento

1. Abrir o DBeaver.
2. Clicar em **Database → New Database Connection**.
3. Selecionar **PostgreSQL** na lista de bancos de dados.
4. Avançar para a próxima etapa.

Na janela de configuração da conexão, normalmente utilizam-se os seguintes parâmetros:

* **Host:** localhost
* **Port:** 5432 (porta padrão do PostgreSQL)
* **Database:** postgres (banco de dados padrão) mas podemos colocar o nome do nosso banco de dados **projeto_estudos** ou selecionar a opção "Show all databases"
* **User:** postgres
* **Password:** senha definida anteriormente

Após preencher os campos, clicar em **Test Connection**.

Se o teste for bem-sucedido, finalize a criação da conexão. Nesse momento, o DBeaver estará conectado ao servidor PostgreSQL em execução no próprio computador.

## Criando o dir do Projeto para versionar o histórico evolutivo do nosso banco de dados seguindo as boas práticas

Voltando para a raiz do usuário do seu sistema operacional, você pode criar um novo dir chamado SQL-Projects ou em algum outro dir de sua preferência. Essa diretório servirá para armazenar os scripts sqls que vamos utilizar durante o projeto e podemos versionar e ter um controle evolutivo do banco de dados, tanto para reproduzir ou apenas consultar como banco de dados evolui ao longo do tempo. Versionar o projeto com Git é exatamente a prática moderna conhecida como Database as Code. A ideia é tratar a estrutura do banco da mesma forma que se trata código-fonte. O objetivo também é a alinhar nosso projeto com boas práticas.

Criando nosso diretório do projeto:

```
mkdir ~/SQL-Projects
```
A estrutura de dir que vamos utilizar é seguinte:

```
SQL-Projects/
└─ projeto_estudo/
   │
   ├─ sql/
   │   ├─ schema/
   │   ├─ tables/
   │   ├─ relations/
   │   └─ seed/
   │
   ├─ migrations/
   │
   ├─ docs/
   │
   └─ README.md
```
Explicação breve da função de cada parte:

sql/schema
Define o schema do banco.

sql/tables
Scripts de criação de tabelas.

sql/relations
Chaves estrangeiras e relacionamentos.

sql/seed
Dados de teste.

migrations
Mudanças estruturais futuras no banco.

docs
Diagramas ou explicações do modelo.

Agora chegamos ao último componente: o versionamento.

Versionar o projeto com Git é exatamente a prática moderna conhecida como Database as Code. A ideia é tratar a estrutura do banco da mesma forma que se trata código-fonte.

Dentro do diretório do projeto:

```
cd ~/SQL-Projects/projeto_estudo
git init
```

Agora poderemos versionar todos os scripts SQL.

Isso cria um benefício poderoso: qualquer pessoa poderia reconstruir o banco executando os scripts do repositório.

Convém notar uma consequência interessante desse modelo. O banco de dados que roda no PostgreSQL passa a ser apenas um artefato derivado. A verdadeira “fonte da verdade” passa a ser o conjunto de scripts versionados.

Resumindo a arquitetura final que  estamos construindo:

Infraestrutura
→ servidor PostgreSQL rodando no sistema

Projeto
→ diretório SQL-Projects/projeto_estudo

Banco
→ projeto_estudos dentro do PostgreSQL

Controle de versão
→ Git armazenando todos os scripts SQL

Essa separação entre infraestrutura, banco e scripts é considerada o padrão de ouro na engenharia moderna de dados.

## Definir o schema do banco.

Convém iniciar com uma pequena reflexão estrutural. Um banco de dados não deve ser concebido como um conjunto improvisado de tabelas. Ele é, antes de tudo, uma representação formal de um domínio do mundo real. A engenharia do banco consiste justamente em traduzir entidades, relações e restrições desse domínio em estruturas relacionais coerentes dentro do PostgreSQL.

O projeto que organizamos no sistema de arquivos está conceitualmente correto. A separação entre servidor de banco, scripts versionados e cliente de administração — como o DBeaver — é exatamente a arquitetura adotada em ambientes profissionais.

A estrutura ideal que adotamos para nosso projeto de estudos assumiu a seguinte forma conceitual:

```
SQL-Projects/
└─ projeto_estudo/
   │
   ├─ sql/
   │   ├─ schema/
   │   ├─ tables/
   │   ├─ relations/
   │   └─ seed/
   │
   ├─ migrations/
   │
   ├─ docs/
   │
   └─ README.md
```
Observe a lógica. Cada arquivo possui uma responsabilidade específica. Essa separação é uma prática muito difundida porque permite compreender a evolução do banco ao longo do tempo quando o projeto é versionado com Git.

Passemos agora ao primeiro passo real da construção: definir o schema do banco.

Em PostgreSQL, um schema é um espaço de nomes que agrupa tabelas, índices, funções e outros objetos. É possível pensar nele como um “subdomínio organizacional” dentro do banco.

Crie o primeiro arquivo do projeto:

```
nano ~/SQL-Projects/projeto_estudo/sql/01_schema.sql
```
Dentro dele escreva:

```
CREATE SCHEMA estudo;

COMMENT ON SCHEMA estudo IS 'Schema principal do projeto de estudo de SQL';
```

Esse pequeno script já estabelece duas coisas importantes:

cria um espaço lógico chamado estudo

documenta o propósito desse espaço

Salve o arquivo.

Agora vamos executá-lo no banco projeto_estudos.

Primeiro conecte-se ao banco:

```
psql -U postgres -d projeto_estudos
```
Dentro do terminal do PostgreSQL execute:
```
\i ~/SQL-Projects/projeto_estudo/sql/01_schema.sql
```
Se tudo ocorreu corretamente, o PostgreSQL responderá com algo semelhante a:

```
CREATE SCHEMA
COMMENT
```
Nesse momento nosso banco já possui uma estrutura inicial formalizada em script, que é exatamente o princípio fundamental de engenharia de bancos de dados: tudo deve nascer de scripts versionados, não de cliques na interface gráfica.

Existe um detalhe elegante aqui. Muitos iniciantes colocam todas as tabelas diretamente no schema padrão chamado public. Em projetos maiores, isso rapidamente se torna caótico. Criar um schema próprio desde o início é uma disciplina arquitetônica que poupa inúmeros problemas no futuro.

## Criando o usuário para o banco de dados

O superusuário postgres permanece reservado para administração do servidor, enquanto cada projeto ou aplicação utiliza usuários próprios com permissões limitadas. Essa prática reduz drasticamente o risco de alterações acidentais ou destrutivas.

O procedimento conceitualmente correto consiste em três etapas:

criar um usuário do banco

definir uma senha para esse usuário

conceder privilégios sobre o banco do projeto

Tudo isso deve ser feito enquanto você está conectado como administrador no PostgreSQL.

Primeiro, entre no servidor:

```
sudo -u postgres psql

```
Agora criaremos um usuário específico para o projeto. Em PostgreSQL, usuários são chamados de roles.

Execute:

```
CREATE ROLE lucas_estudo
WITH LOGIN
PASSWORD 'senha_forte_aqui';
```

Esse comando cria um usuário capaz de realizar login no servidor.

Agora precisamos conceder acesso ao banco projeto_estudos:

```
GRANT ALL PRIVILEGES ON DATABASE projeto_estudos TO lucas_estudo;
```
Isso permite que o usuário se conecte e trabalhe dentro desse banco.

Em seguida, entre no banco do projeto:

```
\c projeto_estudos
```
Agora conceda controle sobre o schema que criamos:

```
GRANT ALL ON SCHEMA estudo TO lucas_estudo;
```
E também permita criar objetos dentro dele:

```
ALTER SCHEMA estudo OWNER TO lucas_estudo;
```
Nesse momento, a estrutura de permissões do seu projeto passa a ter a seguinte forma conceitual:

Administrador do servidor
→ postgres

Usuário do projeto
→ lucas_estudo

Banco do projeto
→ projeto_estudos

Schema do projeto
→ estudo

Agora você pode conectar diretamente usando esse novo usuário:

```
psql -U lucas_estudo -d projeto_estudos
```
ou criar uma nova conexão no DBeaver utilizando:

Host

localhost

Database

projeto_estudos

User

lucas_estudo

Senha
→ a senha definida no comando CREATE ROLE.

Esse arranjo possui uma elegância arquitetônica notável. O superusuário continua sendo o administrador da infraestrutura, enquanto o usuário do projeto passa a ser o responsável apenas pelo domínio da aplicação.

Em sistemas grandes, essa ideia se expande ainda mais. É comum encontrar:

um usuário para migrações de banco

um usuário apenas para leitura

um usuário usado pela aplicação

o superusuário administrativo

Essa segmentação transforma o banco de dados em um sistema com camadas claras de responsabilidade, algo muito próximo do que encontramos em arquitetura de sistemas operacionais.

Uma vez criado esse usuário do projeto, o próximo passo lógico no seu laboratório de estudo será algo extremamente instrutivo: executar os scripts SQL do projeto utilizando esse usuário não privilegiado, exatamente como ocorreria em um ambiente real de desenvolvimento. Isso revela rapidamente se a estrutura de permissões foi bem concebida.

