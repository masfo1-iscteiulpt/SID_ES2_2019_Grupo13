package Sid_Grupo13.Monitorizador;

import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;

public class Poller{

	String topic; 
	String broker;
	String clientId;
	MemoryPersistence persistence = new MemoryPersistence();
	MqttClient sampleClient;
	MqttConnectOptions connOpts;
	
	
	public Poller(String topic,String broker,String clientId,MqttCallback callback) {
		try {
			this.topic=topic;
			this.broker=broker;
			this.clientId=clientId;
			sampleClient=new MqttClient(broker, clientId, persistence);
			sampleClient.setCallback(callback);
			connOpts= new MqttConnectOptions();
			connOpts.setCleanSession(true);
		} catch (MqttException me) {
			exeptionMessage(me);
		}
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
