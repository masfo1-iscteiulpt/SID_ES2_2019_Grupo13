package Sid_Grupo13.Investigador;

import java.io.IOException;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ResourceBundle;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Label;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.stage.Stage;

public class LoginController implements Initializable {

	public TextField username;
	public PasswordField password;
	public TextField address;
	public TextField port;
	public Label error;

	public void initialize(URL location, ResourceBundle resources) {
		address.setText("localhost");
		port.setText("3306");
	}

	@FXML
	private void login(ActionEvent actionEvent) throws IOException {
		try {
			Connection connection = DriverManager.getConnection("jdbc:mariadb://" + address.getText() + ":"
					+ port.getText() + "/sid2019?user=" + username.getText() + "&password=" + password.getText());

			((Stage) ((Node) actionEvent.getSource()).getScene().getWindow()).close();
			openMainWindow(connection);
		} catch (SQLException e) {
			error.setText("Login errado");
		}
	}

	private void openMainWindow(Connection connection) throws IOException {
		Stage stage = new Stage();
		FXMLLoader loader = new FXMLLoader();
		loader.setController(new MainController(connection));
		loader.setLocation(getClass().getResource("Main.fxml"));
		Parent root = loader.load();

		stage.setTitle("Estufex for Investigator");
		stage.setMinHeight(480);
		stage.setMinWidth(680);

		stage.setScene(new Scene(root));
		stage.show();
		root.requestFocus();
	}
}