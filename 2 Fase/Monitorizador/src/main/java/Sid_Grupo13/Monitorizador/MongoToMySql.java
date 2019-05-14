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
	int percentagediff = 10;

	public static void main(String[] args) throws InterruptedException, ParseException {
		// criar user para nao utilizar o root
		while(true) {
		MongoToMySql m = new MongoToMySql();
		int setsize = 10;
		FindIterable<Document> found = m.mongoConnector.queryFromLastExported();
		ArrayList<Document> evenlist = new ArrayList<Document>();
		
		for (Document d : found) {
			if (evenlist.size() >= setsize) {
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

	private Leitura even(ArrayList<Document> parsedlist, int percentagediff) {
		
		Double tmpsum = 0.0;
		Double count = 0.0;
		Double cellsum = 0.0;
		boolean repeat = true;
		ArrayList<Document> removelist=new ArrayList<Document>();
		while (repeat) {
			repeat = false;
			tmpsum = 0.0;
			count = 0.0;
			cellsum = 0.0;
			for (Document l : parsedlist) {
				tmpsum += l.getDouble("tmp");
				cellsum += l.getInteger("cell");
				count++;
			}
			tmpsum /= count;
			cellsum /= count;
			for (Document l : parsedlist) {
				if ((((Math.abs((l.getDouble("tmp") - tmpsum) * 100)) / (tmpsum)) > percentagediff)
						|| (((Math.abs((l.getInteger("cell") - cellsum) * 100)) / (cellsum)) > percentagediff)) {
					repeat = true;
					removelist.add(l);
				}
			}
			for(Document l:removelist)parsedlist.remove(l);
		}
		if (!parsedlist.isEmpty()) {
			Document last = parsedlist.get(parsedlist.size()-1);
			return new Leitura(tmpsum, last.getString("tim"), last.getString("dat"), cellsum.intValue(),
					last.getInteger("readid"));
		}
		return null;
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
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
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