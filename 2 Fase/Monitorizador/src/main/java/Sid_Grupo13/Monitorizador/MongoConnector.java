package Sid_Grupo13.Monitorizador;

import org.bson.Document;
import org.codehaus.jackson.map.ObjectMapper;

import com.mongodb.MongoClient;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;


public class MongoConnector {
	private String targetDB;
	MongoClient mongoClient;
	private MongoDatabase database;
	private MongoCollection<Document> mc;
	
	MongoConnector(String targetDB){
		this.targetDB=targetDB;
		mongoClient = new MongoClient("localhost", 27017);
		database = mongoClient.getDatabase(targetDB);
		getCollection();
	}
	
	public void getCollection(){
		mc=database.getCollection(targetDB);
	}
	
	public void insertJson(String json) {
		getCollection();
		mc.insertOne(Document.parse(json));
	}
	
	public FindIterable<Document> queryCollection() {
		getCollection();
		return mc.find();
	}
}
