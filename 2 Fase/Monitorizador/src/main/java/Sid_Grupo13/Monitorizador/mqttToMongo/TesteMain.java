package Sid_Grupo13.Monitorizador.mqttToMongo;

import java.util.Scanner;

import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;

import Sid_Grupo13.Monitorizador.MongoConnector;

public class TesteMain {
	public static void main(String[] args) {
		MongoConnector mconn = new MongoConnector("Leituras");
		System.out.println(mconn.getIndex());
		mconn.incrementIndex();
	}
}
