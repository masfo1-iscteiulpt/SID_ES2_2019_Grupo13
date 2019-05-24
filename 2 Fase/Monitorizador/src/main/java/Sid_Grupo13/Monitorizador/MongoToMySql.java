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
	
	public static void main(String[] args) throws InterruptedException, ParseException {
		// criar user para nao utilizar o root
		MySqlConnector mysqlConnector = new MySqlConnector("jdbc:mariadb://localhost:3306/"+args[0], args[1],args[2]);
		MongoConnector mongoConnector = new MongoConnector("Leituras");
		int setsize=Integer.parseInt(args[3]);
		int sleeptime=Integer.parseInt(args[4]);
		MongoToMySql m=new MongoToMySql();
		while (true) {

			FindIterable<Document> found = mongoConnector.queryFromLastExported();
			ArrayList<Document> evenlist = new ArrayList<Document>();

			for (Document d : found) {
				if (evenlist.size() > setsize) {
					m.store(m.median(evenlist),mongoConnector,mysqlConnector);
					evenlist.clear();
				}
				evenlist.add(d);
			}
			evenlist.clear();

			Thread.sleep(sleeptime);
		}
	}

	private Leitura median(ArrayList<Document> parsedlist) {
		Double[] temps = new Double[parsedlist.size()];
		int[] cells = new int[parsedlist.size()];
		int i = 0;
		for (Document l : parsedlist) {
			temps[i] = ((l.get("tmp") != null) ? l.getDouble("tmp") : 0.0);
			cells[i] = l.getInteger("cell", 0);
			i++;
		}
		Arrays.sort(temps);
		Arrays.sort(cells);
		double mediantmp;
		int mediancell;
		if (parsedlist.size() % 2 == 0) {
			mediantmp = ((double) temps[temps.length / 2] + (double) temps[temps.length / 2 - 1]) / 2;
			mediancell = (cells[cells.length / 2] + cells[cells.length / 2 - 1]) / 2;
		} else {
			mediantmp = (double) temps[temps.length / 2];
			mediancell = cells[cells.length / 2];
		}

		Document last = parsedlist.get(parsedlist.size() / 2);

		return new Leitura(mediantmp, last.getString("tim"), last.getString("dat"), mediancell,
				last.getInteger("readid"));
	}

	private void store(Leitura even,MongoConnector mongoConnector,MySqlConnector mySqlConnector) {
		if (even != null) {
			System.out.println(even.toMongoStringCurrentID());
			Timestamp timestamp = getTimestamp(even.getDat(), even.getTim());
			int id = even.getId();
			double light = (even.getCell());
			double temperature = (even.getTmp());

			mySqlConnector.insert("medicoes_temperatura", id, timestamp, temperature);
			mySqlConnector.insert("medicoes_luminosidade", id, timestamp, light);
			mongoConnector.incrementLastExported(even.getId());
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