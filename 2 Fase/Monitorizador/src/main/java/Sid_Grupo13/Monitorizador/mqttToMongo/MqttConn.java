package Sid_Grupo13.Monitorizador.mqttToMongo;

import java.util.ArrayList;
import java.util.Scanner;

import org.bson.Document;
import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttMessage;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.mongodb.BasicDBObject;
import com.mongodb.client.FindIterable;

import Sid_Grupo13.Monitorizador.MongoConnector;
import Sid_Grupo13.Monitorizador.models.Leitura;

public class MqttConn {
	public static void main(String[] args) {
		String topic=args[0];
		String server=args[1];
		MongoConnector mconn = new MongoConnector("Leituras");
		MqttCallback callback = new MongoMqttCallback(mconn);
		Poller p=new Poller(topic, server, "MqttReciever", callback);
		p.connect();
		p.subscribe();
		System.out.println("Pressione uma tecla para sair...");
		Scanner sc = new Scanner(System.in);
		sc.nextLine();
		System.out.println("adeus");
		sc.close();
		p.disconnect();
	}
	
}