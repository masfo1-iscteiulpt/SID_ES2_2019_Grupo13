package Sid_Grupo13.Monitorizador;

import org.bson.Document;

import com.mongodb.client.FindIterable;

public class MongoToMySql {
	public static void main(String[] args) {
		MySqlConnector mysqlconn=new MySqlConnector("jdbc:mariadb://localhost:3306/maindb","root","");
		MongoConnector mongoconn=new MongoConnector("teste");
		FindIterable<Document> found=mongoconn.queryCollection();
		for(Document d:found) {
			System.out.println(d.get("tmp"));
		}
	}
}
