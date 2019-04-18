package Sid_Grupo13.Monitorizador;

import org.bson.Document;

import com.mongodb.MongoClient;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;


public class MongoConnector {
	MongoClient mongoClient;
	
	public static void main(String[] args) {
		new MongoConnector();
	}
	MongoConnector(){
		mongoClient = new MongoClient("localhost", 27017);
		MongoDatabase database = mongoClient.getDatabase("teste");
		MongoCollection<Document> mc=database.getCollection("teste");
		FindIterable<Document> found=mc.find();
		for(Document d:found) {
			System.out.println(d.toJson());
		}
		
	}
}
