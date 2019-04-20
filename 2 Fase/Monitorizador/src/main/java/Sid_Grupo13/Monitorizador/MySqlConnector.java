package Sid_Grupo13.Monitorizador;

import java.sql.Array;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

public class MySqlConnector {
	
	Connection conn;
	public static void main(String[] args) {
		new MySqlConnector("jdbc:mariadb://localhost:3306/maindb","root","").insert("medicoes_luminusidade",new Timestamp(System.currentTimeMillis()),2.0);
	}
	public MySqlConnector(String uri,String user,String password) {
		try {
			conn = DriverManager.getConnection(uri+"?user="+user+"&password="+password);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void executeQuery() {
		PreparedStatement stmt;
		try {
			stmt = conn.prepareStatement("Select max(idcultura) from cultura;");
			ResultSet set=stmt.executeQuery();
			System.out.println(set.toString());
			set.next();
			System.out.println(set.getInt(1));
		} catch (SQLException e) {
			e.printStackTrace();
		}
			
	}
	
	public void insert(String table,Timestamp date,double value) {
		try {
			PreparedStatement stmt = conn.prepareStatement("insert into "+table+" values(0,?,?);");
			stmt.setTimestamp(1, date);
			stmt.setDouble(2, value);
			stmt.execute();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
