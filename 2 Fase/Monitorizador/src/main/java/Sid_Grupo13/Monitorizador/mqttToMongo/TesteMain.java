package Sid_Grupo13.Monitorizador.mqttToMongo;

import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;

import Sid_Grupo13.Monitorizador.MongoConnector;

public class TesteMain {
	public static void main(String[] args) {
		Poller p=new Poller("olaola", "tcp://broker.hivemq.com:1883", "tonhocicletas", new MongoMqttCallback(new MongoConnector("")));
		p.connect();
		for (int i = 0; i < 20; i++) {
			try {
				p.sampleClient.publish(p.topic, new MqttMessage("ola".getBytes()));
			} catch (MqttException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		p.disconnect();
		
	}
}
