package Sid_Grupo13.Monitorizador;

import org.bson.Document;

import com.mongodb.MongoClient;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;

public class MongoConnector {

	private MongoClient mongoClient;
	private MongoDatabase mongoDatabase;
	private MongoCollection<Document> mongoCollection;
	
	public static void main(String[] args) {
		MongoConnector mconn = new MongoConnector("Leituras");
		int id=MqttConn.getIndex(mconn);
		mconn.getCollection("sensor");
		mconn.insertJson("{\"readid\":\"2\",\"tmp\":\"21.40\",\"dat\":\"11/4/2019\",\"tim\":\"14:00:32\",\"cell\":\"2138\"}");
		
	}
	public MongoConnector(String database) {
		mongoClient = new MongoClient("localhost", 27017);
		mongoDatabase = mongoClient.getDatabase(database);
	}

	public void getCollection(String collection) {
		mongoCollection = mongoDatabase.getCollection(collection);
	}

	public void insertJson(String json) {
		mongoCollection.insertOne(Document.parse(json));
	}

	public FindIterable<Document> queryCollection() {
		return mongoCollection.find();
	}
	
	public String getNamespace() {
		return mongoCollection.getNamespace().getFullName();
	}
}