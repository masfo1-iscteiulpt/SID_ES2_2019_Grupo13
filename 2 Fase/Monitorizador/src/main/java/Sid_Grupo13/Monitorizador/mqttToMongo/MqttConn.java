package Sid_Grupo13.Monitorizador.mqttToMongo;

import java.util.ArrayList;
import java.util.Scanner;

import org.bson.Document;
import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttMessage;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.mongodb.client.FindIterable;

import Sid_Grupo13.Monitorizador.MongoConnector;
import Sid_Grupo13.Monitorizador.models.Leitura;

public class MqttConn {
	static int samplesize=10;
	static int percentagediff=10;
	public static void main(String[] args) {
		MongoConnector mconn = new MongoConnector("Leituras");
		MqttCallback callback = new MongoMqttCallback(mconn);
		Poller p=new Poller("olaola", "tcp://broker.hivemq.com:1883", "clientszdfsdfe", callback);
		p.connect();
		p.subscribe();
		System.out.println("Pressione uma tecla para sair...");
		Scanner sc = new Scanner(System.in);
		sc.nextLine();
		System.out.println("adeus");
		sc.close();
		p.disconnect();
	}
	
	public static int getIndex(MongoConnector mconn) {
		mconn.getCollection("index");
		FindIterable<Document> index=mconn.queryCollection();
		Document d=index.first();
		return Integer.parseInt(d.get("index", String.class));
	}
	
	public static void incrementIndex(MongoConnector mconn) {
		mconn.getCollection("index");
		FindIterable<Document> index=mconn.queryCollection();
		Document d=index.first();
		int i=Integer.parseInt(d.get("index", String.class));
		i++;
	}
}