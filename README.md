# SID_ES2_2019_Grupo13

Grupo:  
André Almeida nº65598  
Diogo Sarmento nº78463  
Hugo Cruz nº78001  
Luís Fernandes nº78009  
Miguel Figueiredo nº77577  
Rostislav Andreev nº77689  

Opção escolhida para a entrega do projeto:  
Instruções, passo a passo, de como fazer o download da aplicação, a instalação e a execução do software.  

# Instruções

Requirements:
	- Windows 10;
	- Java 1.8;
	- MongoDB;
	- XAMPP;
	- Abrir porta 80 na firewall do Windows.

Procedure:
	- Executar mongod.exe na linha de comandos;
	- Colocar a pasta dump na pasta de instalacão Mongo e executar mongorestore.exe;
	- Executar os servicos Apache e MySQL no painel de controlo XAMPP (xampp-control.exe);
	- Aceder a página de administração phpMyAdmin e importar os ficheiros sid.sql e auditor.sql presentes na pasta mysql;
	- Copiar os conteudos da pasta htdocs para {pasta de instalação do XAMPP}\htdocs;
	- Criar uma task no Task Schedueler do Windows como periodicidade de execução de 30 em 30 minutos que executa o seguinte comando numa linha de comandos: "php {pasta de instalação do xampp}\htdocs\migration.php".

Lançamento do sistema:
	- Executar mongod.exe na linha de comandos;
	- Garantir que se encontram em execução os serviços Apache e MySQL no painel de controlo XAMPP;
	- Executar o ficheiro MqttConn.jar da seguinte forma na linha de comandos: "java -jar MqttConn.jar /sid_lab_2019 tcp://iot.eclipse.org";
	- Executar o ficheiro MongoToMySql.jar da seguinte forma na linha de comandos:  "java -jar MongoToMySql.jar sid2019 mongo mongo 3 2000";
	- Ambos os programas encontram se na pasta jars e devem ser deixados em execução durante a utilização do sistema.

Administrador:
	- Executar o programa Administrador.jar para execução das suas funções de manutenção de variaveis e utilizadores;
	- Existe por predefenição credenciais para um administrador, sendo estas username: admin e password: admin.

Auditor:
	- Para realizar o acesso à base de dados o auditor deve procurar no seu browser o segunte endereço http://localhost/auditor.html (interface de auditoria).

Investigador:
	- Executar o programa Investigador.jar para execução das suas funções de manutenção de culturas e medições;
	- Na pasta apk encorntra-se o ficheiro .apk relativo à aplicaçao de monitorização remota desenhada para o investigador. O investigador deve instala-la no seu dispositivo Android.
