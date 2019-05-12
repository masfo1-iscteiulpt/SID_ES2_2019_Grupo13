package Sid_Grupo13.Administrador;

import java.net.URL;
import java.util.ResourceBundle;

import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Paint;

public class MainController implements Initializable {

	public Button showVariables;
	public Button showUsers;

	public VBox variablesPane;
	public VBox usersPane;

	public void initialize(URL location, ResourceBundle resources) {
		showVariables();
	}

	public void showVariables() {
		showVariables.setStyle("-fx-background-color: #ffffff");
		showVariables.setTextFill(Paint.valueOf("#000000"));
		showUsers.setStyle("-fx-background-color: #05BC78");
		showUsers.setTextFill(Paint.valueOf("#ffffff"));
		variablesPane.toFront();
	}

	public void showUsers() {
		showUsers.setStyle("-fx-background-color: #ffffff");
		showUsers.setTextFill(Paint.valueOf("#000000"));
		showVariables.setStyle("-fx-background-color: #05BC78");
		showVariables.setTextFill(Paint.valueOf("#ffffff"));
		usersPane.toFront();
	}
}