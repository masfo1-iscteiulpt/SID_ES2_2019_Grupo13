package Sid_Grupo13.Monitorizador;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import org.bson.Document;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.mongodb.client.FindIterable;

import Sid_Grupo13.Monitorizador.models.Leitura;

public class MongoToMySql {

	MySqlConnector mysqlConnector = new MySqlConnector("jdbc:mariadb://localhost:3306/sid2019", "root", "123");
	MongoConnector mongoConnector = new MongoConnector("Leituras");
	Double percentagediff = 1.1;
	static int setsize = 1;

	public static void main(String[] args) throws InterruptedException, ParseException {
		// criar user para nao utilizar o root
		while (true) {
			MongoToMySql m = new MongoToMySql();

			FindIterable<Document> found = m.mongoConnector.queryFromLastExported();
			ArrayList<Document> evenlist = new ArrayList<Document>();

			for (Document d : found) {
				if (evenlist.size() > setsize) {
					m.store(m.even(evenlist, m.percentagediff));
					evenlist.clear();
				}
				evenlist.add(d);
			}
			evenlist.clear();
			Thread.sleep(2000);
		}
//		Timestamp timestamp = getTimestamp(d.getString("dat"), d.getString("tim"));
//		int id = d.getInteger("readid");
//		double light = (d.getInteger("cell"));
//		double temperature = (d.getDouble("tmp"));
//
//		mysqlConnector.insert("medicoestemperatura", id, timestamp, temperature);
//		mysqlConnector.insert("medicoesluminosidade", id, timestamp, light);
	}

	private Leitura even(ArrayList<Document> parsedlist, Double percentagediff) {
		
		
		    int maxValue, maxCount;

		    for (int i = 0; i < a.length; ++i) {
		        int count = 0;
		        for (int j = 0; j < a.length; ++j) {
		            if (a[j] == a[i]) ++count;
		        }
		        if (count > maxCount) {
		            maxCount = count;
		            maxValue = a[i];
		        }
		    }

		    return maxValue;
//		double tm = 0.;
//		double lm = 0.;
//		double count = 0.;
//		
//		double tmp = 0.;
//		double cell = 0.;
//		double tcount = 0.;
//		double lcount= 0.;
//		
//		for(Document d : parsedlist) {
//			tm += d.getDouble("tmp");
//			lm += d.getDouble("cell");
//			count++;
//		}
//		
//		tm /= count;
//		lm /= count;
//		
//		for(Document d : parsedlist) {
//			if() {
//				tmp += d.getDouble("tmp");
//				tcount++;
//			}
//			
//			if() {
//				cell += d.getDouble("cell");
//				lcount++;
//			}
//		}
//		
//		tmp /= tcount;
//		cell /= lcount;
//		
//		Double tmpsum = 0.0;
//		Double count = 0.0;
//		Double cellsum = 0.0;
//		boolean repeat = true;
//		Document last = parsedlist.get(0);
//		ArrayList<Document> removelist = new ArrayList<Document>();
//		while (repeat) {
//			repeat = false;
//			tmpsum = 0.0;
//			count = 0.0;
//			cellsum = 0.0;
//			for (Document l : parsedlist) {
//				tmpsum += l.getDouble("tmp");
//				cellsum += l.getInteger("cell");
//				last=l;
//				count++;
//			}
//			tmpsum /= count;
//			cellsum /= count;
//			for (Document l : parsedlist) {
//				if (l.getDouble("tmp")>percentagediff*tmpsum||l.getDouble("tmp")<percentagediff*tmpsum
//						||l.getDouble("cell")>percentagediff*cellsum||l.getDouble("cell")<percentagediff*cellsum ) {
//					repeat = true;
//					removelist.add(l);
//				}
//			}
//			for(Document l: removelist) {
//				parsedlist.remove(l);
//			}
//		}
//			return new Leitura(tmpsum, last.getString("tim"), last.getString("dat"), cellsum.intValue(),
//					last.getInteger("readid"));
	}

	private void store(Leitura even) {
		if (even != null) {
			System.out.println(even.toMongoStringCurrentID());
			Timestamp timestamp = getTimestamp(even.getDat(), even.getTim());
			int id = even.getId();
			double light = (even.getCell());
			double temperature = (even.getTmp());

			mysqlConnector.insert("medicoes_temperatura", id, timestamp, temperature);
			mysqlConnector.insert("medicoes_luminosidade", id, timestamp, light);
			mongoConnector.incrementLastExported(even.getId());
			// acabar esta funcao e o increment index
		} else {
			System.out.println("todos os elementos invalidos(demasiada variacao)");
		}
	}

	public static Timestamp getTimestamp(String day, String hour) {
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		String timestamp = day + " " + hour;
		Date date;
		try {
			date = simpleDateFormat.parse(timestamp);
		} catch (ParseException e) {
			date = new Date(System.currentTimeMillis());
		}

		return new Timestamp(date.getTime());
	}
}