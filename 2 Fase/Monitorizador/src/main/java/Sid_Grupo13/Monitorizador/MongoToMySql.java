package Sid_Grupo13.Monitorizador;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;

import org.bson.Document;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.mongodb.client.FindIterable;

import Sid_Grupo13.Monitorizador.models.Leitura;

public class MongoToMySql {

	MySqlConnector mysqlConnector = new MySqlConnector("jdbc:mariadb://localhost:3306/sid2019", "root", "123");
	MongoConnector mongoConnector = new MongoConnector("Leituras");
	static int setsize = 3;

	public static void main(String[] args) throws InterruptedException, ParseException {
		// criar user para nao utilizar o root
		MongoToMySql m = new MongoToMySql();
		while (true) {
			

			FindIterable<Document> found = m.mongoConnector.queryFromLastExported();
			ArrayList<Document> evenlist = new ArrayList<Document>();

			for (Document d : found) {
				if (evenlist.size() > setsize) {
					m.store(m.even(evenlist));
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

	private Leitura even(ArrayList<Document> parsedlist) {
		Double[] temps=new Double[parsedlist.size()];
		int[] cells=new int[parsedlist.size()];
		int i=0;
		for(Document l:parsedlist) {
			temps[i]=((l.get("tmp")!=null)?l.getDouble("tmp"):0.0);
			cells[i]=l.getInteger("cell",0);
			i++;
		}
		Arrays.sort(temps);
		Arrays.sort(cells);
		double mediantmp;
		int mediancell;
		if (parsedlist.size() % 2 == 0) {
		    mediantmp = ((double)temps[temps.length/2] + (double)temps[temps.length/2 - 1])/2;
			mediancell= (cells[cells.length/2] + cells[cells.length/2 - 1])/2;
		}else {
		    mediantmp = (double) temps[temps.length/2];
			mediancell= cells[cells.length/2];
		}
		
		Document last = parsedlist.get(parsedlist.size()/2);
		
			return new Leitura(mediantmp, last.getString("tim"), last.getString("dat"), mediancell,
					last.getInteger("readid"));
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
			System.out.println("nenhum elemento guardado");
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