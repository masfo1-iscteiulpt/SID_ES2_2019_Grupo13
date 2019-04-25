package Sid_Grupo13.Monitorizador;

import java.util.ArrayList;
import java.util.Scanner;

import org.bson.Document;
import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttMessage;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.mongodb.client.FindIterable;

public class MqttConn {
	static int samplesize=10;
	static int percentagediff=10;
	public static void main(String[] args) {
		MongoConnector mconn = new MongoConnector("Leituras");
		MqttCallback callback = new MqttCallback() {
			ArrayList<MqttMessage> list = new ArrayList<MqttMessage>();
			@Override
			public void messageArrived(String topic, MqttMessage message) throws Exception {
				list.add(message);
				validateAndStore();
			}

			private void validateAndStore() {
				ArrayList<Leitura> parsedlist=new ArrayList<Leitura>();
				if(list.size()==samplesize) {
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
						if((((Math.abs((l.tmp-tmpsum)*100))/(tmpsum))>percentagediff)||(((Math.abs((l.cell-cellsum)*100))/(cellsum))>percentagediff)){
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
					int index=getIndex(mconn);
					//acabar esta funcao e o increment index
				}
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
	
	public static void incrementIndex(MongoConnector mconn) {
		mconn.getCollection("index");
		FindIterable<Document> index=mconn.queryCollection();
		Document d=index.first();
		int i=Integer.parseInt(d.get("index", String.class));
		i++;
	}
}