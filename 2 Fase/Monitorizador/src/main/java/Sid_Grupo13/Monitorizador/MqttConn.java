package Sid_Grupo13.Monitorizador;

import java.awt.image.SampleModel;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Scanner;

import org.bson.Document;
import org.codehaus.jackson.JsonNode;
import org.codehaus.jackson.JsonProcessingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.map.util.JSONPObject;
import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttMessage;

import com.mongodb.client.FindIterable;
import com.mongodb.util.JSON;

public class MqttConn {
	static int samplesize=10;
	public static void main(String[] args) {
		MongoConnector mconn = new MongoConnector("Leituras");
		MqttCallback callback = new MqttCallback() {
			ArrayList<MqttMessage> list = new ArrayList<MqttMessage>();
			@Override
			public void messageArrived(String topic, MqttMessage message) throws Exception {
				list.add(message);
				evenAndStore();
			}

			private void evenAndStore() {
				if(list.size()==samplesize) {
					for(MqttMessage msg:list) {
						System.out.println(msg.toString());
						try {
							JsonNode json=validate(msg.toString());
							System.out.println(json.getTextValue());
						} catch (IOException e) {
							System.out.println("removida");
							list.remove(msg);
						}
					}
					list.clear();
				}
				
			}

			private JsonNode validate(String string) throws JsonProcessingException, IOException {
				return new ObjectMapper().readTree(string);
			}

			@Override
			public void deliveryComplete(IMqttDeliveryToken token) {
			}

			@Override
			public void connectionLost(Throwable cause) {
				System.exit(0);
			}
		};
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
}