package Sid_Grupo13.Monitorizador;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.bson.Document;

import com.mongodb.client.FindIterable;

public class MongoToMySql {

	public static void main(String[] args) throws InterruptedException, ParseException {
		MySqlConnector mysqlConnector = new MySqlConnector("jdbc:mariadb://localhost:3306/dbsid", "root", "");
		MongoConnector mongoConnector = new MongoConnector("Leituras");
		mongoConnector.getCollection("sensor");
		FindIterable<Document> found = mongoConnector.queryCollection();

		for (Document d : found) {
			Timestamp timestamp = getTimestamp(d.getString("dat"), d.getString("tim"));
			int id = d.getInteger("readid");
			double light = (d.getInteger("cell"));
			double temperature = (d.getDouble("tmp"));

			mysqlConnector.insert("medicoestemperatura", id, timestamp, temperature);
			mysqlConnector.insert("medicoesluminosidade", id, timestamp, light);
		}
	}

	public static Timestamp getTimestamp(String day, String hour) throws ParseException {
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		String timestamp = day + " " + hour;
		Date date = simpleDateFormat.parse(timestamp);

		return new Timestamp(date.getTime());
	}
}