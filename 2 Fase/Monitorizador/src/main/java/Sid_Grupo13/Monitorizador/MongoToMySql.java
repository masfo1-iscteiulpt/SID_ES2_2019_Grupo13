package Sid_Grupo13.Monitorizador;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.bson.Document;

import com.mongodb.client.FindIterable;

public class MongoToMySql {

	public static void main(String[] args) throws InterruptedException, ParseException {
		MySqlConnector mysqlConnector = new MySqlConnector("jdbc:mariadb://localhost:3306/mongo", "root", "123");
		MongoConnector mongoConnector = new MongoConnector("teste", "sensor");
		FindIterable<Document> found = mongoConnector.queryCollection();
		
		for (Document d : found) {
			Timestamp timestamp = getTimestamp(d.getString("dat"), d.getString("tim"));
			double light = Double.parseDouble(d.getString("cell"));
			double temperature = Double.parseDouble(d.getString("tmp"));
			
			mysqlConnector.insert("temperatura", timestamp, temperature);
			mysqlConnector.insert("luz", timestamp, light);
		}
	}

	public static Timestamp getTimestamp(String day, String hour) throws ParseException {
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		String timestamp = day + " " + hour;
		Date date = simpleDateFormat.parse(timestamp);

		return new Timestamp(date.getTime());
	}
}