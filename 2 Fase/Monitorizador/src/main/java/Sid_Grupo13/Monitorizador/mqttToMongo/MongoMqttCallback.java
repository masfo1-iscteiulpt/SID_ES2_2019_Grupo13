package Sid_Grupo13.Monitorizador.mqttToMongo;

import java.util.ArrayList;

import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttMessage;

import com.fasterxml.jackson.databind.ObjectMapper;

import Sid_Grupo13.Monitorizador.MongoConnector;
import Sid_Grupo13.Monitorizador.models.Leitura;

public class MongoMqttCallback implements MqttCallback{
	ArrayList<MqttMessage> list = new ArrayList<MqttMessage>();
	MongoConnector mconn;
	public MongoMqttCallback(MongoConnector mconn) {
		this.mconn=mconn;
	}

	@Override
	public void messageArrived(String topic, MqttMessage message) throws Exception {
		list.add(message);
		validateAndStore();
	}

	private void validateAndStore() {
		ArrayList<Leitura> parsedlist=new ArrayList<Leitura>();
		if(list.size()==MqttConn.samplesize) {
			for(MqttMessage msg:list) {
				System.out.println(msg.toString());
				try {
					Leitura l=validate(msg.toString());
					parsedlist.add(l);
					System.out.println("");
				} catch (Exception e) {
					System.out.println("removida");
					list.remove(msg);
				}
			}
			store(even(parsedlist));
			list.clear();
		}
		
	}

	private Leitura validate(String string) throws Exception {
		Leitura l=new ObjectMapper().readValue(string, Leitura.class);
		if(!l.validate())throw new Exception();
		return l;
	}

	private Leitura even(ArrayList<Leitura> parsedlist) {
		Double tmpsum=0.0;
		Double count=0.0;
		Double cellsum=0.0;
		boolean repeat=true;
		while(repeat) {
			repeat=false;
			tmpsum = 0.0;
			count = 0.0;
			cellsum = 0.0;
			for(Leitura l:parsedlist) {
				tmpsum+=l.tmp;
				cellsum+=l.cell;
				count++;
			}
			tmpsum/=count;
			cellsum/=count;
			for(Leitura l:parsedlist) {
				if((((Math.abs((l.tmp-tmpsum)*100))/(tmpsum))>MqttConn.percentagediff)||
						(((Math.abs((l.cell-cellsum)*100))/(cellsum))>MqttConn.percentagediff)){
					repeat=true;
					parsedlist.remove(l);
				}
			}
		}
		if(!parsedlist.isEmpty()) {
		Leitura last=parsedlist.get(parsedlist.size());
		return new Leitura(tmpsum,last.tim,last.dat,cellsum.intValue());
		}
		return null;
	}
	
	private void store(Leitura even) {
		if(even!=null) {
			int index=mconn.getIndex();
			System.out.println(even.toMongoString(index));
			//acabar esta funcao e o increment index
		}else {
			System.out.println("todos os elementos invalidos(demasiada variacao)");
		}
	}

	@Override
	public void deliveryComplete(IMqttDeliveryToken token) {
	}

	@Override
	public void connectionLost(Throwable cause) {
		System.exit(0);
	}
}
