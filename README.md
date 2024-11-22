## Documentação para o Projeto: Análise de Produções Netflix

### Descrição do Projeto
Este projeto é uma análise ponta a ponta de dados sobre produções disponíveis na Netflix. O objetivo principal é explorar tendências, insights e padrões em filmes e séries utilizando ferramentas e tecnologias de análise de dados. O pipeline abrange desde a obtenção dos dados até a visualização em um dashboard interativo no Power BI.

### Fluxo do Projeto
1. Obtenção dos Dados
   
   - Fonte: Kaggle - Dataset sobre filmes e séries da Netflix.
   - Ferramenta: Python foi utilizado para acessar ai site do Kaggle, realizar o download automático dos arquivos e armazená-los localmente.

2. Inserção dos Dados no Banco de Dados

    - O dataset foi tratado e carregado em um banco de dados MySQL.
    - Ferramentas utilizadas:
      - Python: Para conexão com o MySQL e inserção dos dados.
      - Bibliotecas: pandas, sqlalchemy, entre outras.


3. Processamento e Tratamento dos Dados

   - Os dados foram estruturados em tabelas relacionais no MySQL para facilitar a análise:
     - Tabelas principais: Filmes, Séries, Gêneros, Países de Produção.
     - Criação de dimensões como dim_genre_netflix para facilitar análises por gênero.
       
4. Análises e Insights

   - Foram criadas diversas Views SQL para extrair insights, incluindo:
     - Melhores títulos por gênero e ano.
     - Tendências de gêneros ao longo do tempo.
     - Análises de popularidade por país e ano.
     - Top 10 títulos por pontuação.
     - Distribuição de duração por gênero.

5. Visualização dos Dados

   - Utilização do Power BI para construir um dashboard interativo.
   - Visualizações incluem:
     - Gráficos de linha para tendências ao longo do tempo.
     - Big Numbers para destacar métricas principais (número de títulos, média de avaliações, etc.).
     - Cartões de destaque para "Hidden Gems" e "Overrated".
     - Gráficos de barras e mapas para análise de produção por país.

### Tecnologias Utilizadas
Linguagens e Ferramentas
  - Python.
  - Acesso ao Kaggle.
  - Manipulação de dados com pandas.
  - Conexão com MySQL utilizando sqlalchemy.

MySQL

  - Banco de dados relacional para armazenamento e processamento.
  - Criação de Views SQL para insights e tratamento de dados.

Power BI

  - Construção de um dashboard com gráficos interativos.
  - Integração direta com o banco de dados MySQL.

Bibliotecas e Dependências
  - pandas
  - sqlalchemy
  - kaggle
  - mysql-connector-python
  - tkinter
  - selenium
  - chromedriver_autoinstaller
  - time
  - sys
  - os
  - zipfile
  - smtplib

### Principais Insights
1. Tendências de Lançamentos ao Longo do Tempo
   - Gráficos mostram o crescimento ou declínio de lançamentos por ano.

2. Gêneros Populares
   - Identificação dos gêneros mais frequentes e suas evoluções ao longo do tempo.

3. Distribuição de Duração por Gênero
   - Quais gêneros possuem produções mais longas ou mais curtas?

4. Top 10 Títulos
   - Títulos com melhores avaliações, destacando séries e filmes separadamente.

5. Big Numbers
   - Destaques de métricas principais, como o total de títulos, maior pontuação e número médio de votos.
  
### Dashboard (Em breve atualizações de insights e visuias)

![image](https://github.com/user-attachments/assets/e668fae0-ca36-4b85-8c7e-02ea7f107ef5)

![image](https://github.com/user-attachments/assets/386ba4af-273d-429f-a9ef-2181bdb8fc92)

![image](https://github.com/user-attachments/assets/2931beac-56a0-45b2-b2ee-73c31e055da3)

![image](https://github.com/user-attachments/assets/bc6946c7-7fa5-4981-b931-75e814e47965)
  
### Contribuições

Se tiver dúvidas ou sugestões, sinta-se à vontade para abrir uma issue ou contribuir com melhorias no repositório! 🚀

