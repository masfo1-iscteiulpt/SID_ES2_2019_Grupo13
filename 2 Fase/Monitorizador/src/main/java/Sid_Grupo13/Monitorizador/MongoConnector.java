package Sid_Grupo13.Monitorizador;

import org.bson.Document;

import com.mongodb.BasicDBObject;
import com.mongodb.MongoClient;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;

import Sid_Grupo13.Monitorizador.mqttToMongo.MqttConn;

public class MongoConnector {

	private MongoClient mongoClient;
	private MongoDatabase mongoDatabase;
	private MongoCollection<Document> mongoCollection;

	public MongoConnector(String database) {
		mongoClient = new MongoClient("localhost", 27017);
		mongoDatabase = mongoClient.getDatabase(database);
	}

	public void getCollection(String collection) {
		mongoCollection = mongoDatabase.getCollection(collection);
	}

	// Insere um documento na base de dados
	public void insertJson(String json) {
		mongoCollection.insertOne(Document.parse(json));
	}

	// Retorna uma lista com os documentos todos da coleção selecionada
	public FindIterable<Document> queryCollection() {
		return mongoCollection.find();
	}

	// Retorna todos os documentos da coleção sensor apartir do valor last exported
	public FindIterable<Document> queryFromLastExported() {
		int value = getLastExported();
		this.getCollection("sensor");
		return mongoCollection.find(Filters.gt("readid", value));
	}

	public String getNamespace() {
		return mongoCollection.getNamespace().getFullName();
	}
	//Retorna o valor do index
	public int getIndex() {
		this.getCollection("index");
		FindIterable<Document> index = this.queryCollection();
		Document d = index.first();
		return (d.get("index", Integer.class));
	}
	//Incrementa em 1 o valor do index
	public void incrementIndex() {
		int i = getIndex();
		i++;
		mongoCollection.replaceOne(Filters.exists("index"), new Document("index", i));

	}
	//Retorna o valor de last exported
	public int getLastExported() {
		this.getCollection("last_exported");
		FindIterable<Document> index = this.queryCollection();
		Document d = index.first();
		return (d.get("last_exported", Integer.class));
	}
	//Substitui o valor do last exported
	public void incrementLastExported(int last) {
		getCollection("last_exported");
		mongoCollection.replaceOne(Filters.exists("last_exported"), new Document("last_exported", last));

	}
}