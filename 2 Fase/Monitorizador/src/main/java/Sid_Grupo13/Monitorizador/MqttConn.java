package Sid_Grupo13.Monitorizador;

import java.util.Scanner;

import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttMessage;

public class MqttConn {

	public static void main(String[] args) {
		MongoConnector mconn = new MongoConnector("teste", "teste22");
		MqttCallback callback = new MqttCallback() {
			@Override
			public void messageArrived(String topic, MqttMessage message) throws Exception {
				mconn.insertJson(message.toString());
			}

			@Override
			public void deliveryComplete(IMqttDeliveryToken token) {
			}

			@Override
			public void connectionLost(Throwable cause) {
				System.exit(0);
			}
		};

		new Poller("iscte_sid_2016_S1", "tcp://iot.eclipse.org:1883", "cliente", callback);
		System.out.println("Pressione uma tecla para sair...");
		Scanner sc = new Scanner(System.in);
		sc.nextLine();
		System.out.println("adeus");
		sc.close();
	}
}