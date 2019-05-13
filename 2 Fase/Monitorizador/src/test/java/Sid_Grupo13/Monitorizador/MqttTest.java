package Sid_Grupo13.Monitorizador;

import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;
import org.junit.jupiter.api.Test;

import Sid_Grupo13.Monitorizador.mqttToMongo.MqttConn;
import Sid_Grupo13.Monitorizador.mqttToMongo.Poller;


/**
 * Unit test for simple App.
 */
public class MqttTest
{
	
	
	@Test
    public void pollerTest() {
    	Poller p = new Poller("/sid_lab_2019_2", "tcp://broker.mqtt-dashboard.com:1883", "MqttReciever", new MqttCallback() {
			
			@Override
			public void messageArrived(String topic, MqttMessage message) throws Exception {
				// TODO Auto-generated method stub
				
			}
			
			@Override
			public void deliveryComplete(IMqttDeliveryToken token) {
				// TODO Auto-generated method stub
				
			}
			
			@Override
			public void connectionLost(Throwable cause) {
				// TODO Auto-generated method stub
				
			}
		});
    	p.connect();
    	p.subscribe();
    	p.disconnect();
    	p.exeptionMessage(new MqttException(0));
    }
	
	@Test
	public void mqttConnTest() {
		MqttConn.main(new String[4]);
	}
}
