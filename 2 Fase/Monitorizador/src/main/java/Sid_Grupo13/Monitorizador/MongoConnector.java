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

	public MongoConnector(String database, String collection) {
		mongoClient = new MongoClient("localhost", 27017);
		mongoDatabase = mongoClient.getDatabase(database);
		mongoCollection = mongoDatabase.getCollection(collection);
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