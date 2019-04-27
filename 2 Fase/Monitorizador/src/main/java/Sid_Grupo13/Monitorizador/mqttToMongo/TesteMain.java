package Sid_Grupo13.Monitorizador.mqttToMongo;

import java.util.Scanner;

import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;

import Sid_Grupo13.Monitorizador.MongoConnector;

public class TesteMain {
	public static void main(String[] args) {
		Poller p=new Poller("/sid_lab_2019", "tcp://broker.mqtt-dashboard.com:1883", "olaola", new MqttCallback() {

			@Override
			public void connectionLost(Throwable cause) {
				// TODO Auto-generated method stub
				
			}

			@Override
			public void messageArrived(String topic, MqttMessage message) throws Exception {
				System.out.println(message.toString().replace("\"sens", ",\"sens"));
				
			}

			@Override
			public void deliveryComplete(IMqttDeliveryToken token) {
				// TODO Auto-generated method stub
				
			}
			
		});
		p.connect();
		p.subscribe();
		Scanner sc = new Scanner(System.in);
		sc.nextLine();
		System.out.println("adeus");
		sc.close();
		p.disconnect();
		
	}
}
