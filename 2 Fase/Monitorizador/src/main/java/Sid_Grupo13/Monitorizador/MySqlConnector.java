package Sid_Grupo13.Monitorizador;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

public class MySqlConnector {

	private Connection connection;

	public MySqlConnector(String uri, String user, String password) {
		try {
			connection = DriverManager.getConnection(uri + "?user=" + user + "&password=" + password);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void executeQuery() {
		try {
			PreparedStatement statement = connection.prepareStatement("Select max(idcultura) from cultura;");
			ResultSet set = statement.executeQuery();
			System.out.println(set.toString());
			set.next();
			System.out.println(set.getInt(1));
		} catch (SQLException e) {
			e.printStackTrace();
		}

	}

	public int maxId(String table) {
		try {
			PreparedStatement statement = connection.prepareStatement("Select max(id) from " + table + ";");
			ResultSet resultSet = statement.executeQuery();
			resultSet.next();
			return resultSet.getInt(1);
		} catch (SQLException e) {
			e.printStackTrace();

			return 0;
		}
	}

	public void insert(String table, int id, Timestamp timestamp, double value) {
		try {
			PreparedStatement statement = connection.prepareStatement("insert into " + table + " values(?,?,?);");
			statement.setInt(1, id);
			statement.setTimestamp(2, timestamp);
			statement.setDouble(3, value);
			statement.execute();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}