package Sid_Grupo13.Monitorizador.mqttToMongo;

import java.util.ArrayList;

import org.bson.Document;
import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttMessage;

import com.fasterxml.jackson.databind.ObjectMapper;

import Sid_Grupo13.Monitorizador.MongoConnector;
import Sid_Grupo13.Monitorizador.models.Leitura;

public class MongoMqttCallback implements MqttCallback{
	MongoConnector mconn;
	public MongoMqttCallback(MongoConnector mconn) {
		this.mconn=mconn;
	}

	public void messageArrived(String topic, MqttMessage message) {
		int i = mconn.getIndex();
		mconn.getCollection("sensor");
		try {
			Leitura l=validate(message.toString().replace("\"sens", ",\"sens"));
			mconn.insertJson(l.toMongoString(++i));
			mconn.incrementIndex();
			System.out.println("mensagem guardada: "+message.toString());
		} catch (Exception e) {
			System.out.println("mensagem descartada: "+message.toString());
		} 
	}

	private Leitura validate(String string) throws Exception {
		Leitura l=new ObjectMapper().readValue(string, Leitura.class);
		return l;
	}
	

	public void deliveryComplete(IMqttDeliveryToken token) {
	}

	public void connectionLost(Throwable cause) {
	}
}
