package Sid_Grupo13.Monitorizador;

import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;

public class Poller {

	String topic        = "Teste";
	String content      = "Teste";
	int qos             = 0;
	String broker       = "tcp://iot.eclipse.org:1883";
	String clientId     = "JavaSample";
	MemoryPersistence persistence = new MemoryPersistence();
	MqttClient sampleClient;
	MqttConnectOptions connOpts;
	
	public static void main(String[] args ) throws InterruptedException {
		Poller p=new Poller();
		p.connect();
		p.subscribe();
		while(true) {
		Thread.sleep(4000);
		}
	}	
	
	public Poller() {
		try {
			sampleClient=new MqttClient(broker, clientId, persistence);
			sampleClient.setCallback(createCallback());
			connOpts= new MqttConnectOptions();
			connOpts.setCleanSession(true);
		} catch (MqttException me) {
			exeptionMessage(me);
		}
	}
	
	private MqttCallback createCallback() {
		return new MqttCallback() {
			public void connectionLost(Throwable cause) {}
			public void messageArrived(String topic, MqttMessage message) throws Exception {
				System.out.println(message.toString());
			}
			public void deliveryComplete(IMqttDeliveryToken token) {}
		};
	}

	public void connect() {
		try {
			sampleClient.connect(connOpts);
		} catch(MqttException me) {
			exeptionMessage(me);
		}
	}
	public void disconnect() {
		try {
			sampleClient.disconnect();
		} catch(MqttException me) {
			exeptionMessage(me);
		}
	}


	public void subscribe() {
		try {
			System.out.println("Publishing message: "+content);
			sampleClient.subscribe(topic);
		} catch(MqttException me) {
			exeptionMessage(me);
		} 
	}
	
	public void exeptionMessage(MqttException me) {
		System.out.println("reason "+me.getReasonCode());
		System.out.println("msg "+me.getMessage());
		System.out.println("loc "+me.getLocalizedMessage());
		System.out.println("cause "+me.getCause());
		System.out.println("excep "+me);
		me.printStackTrace();
	}
}
