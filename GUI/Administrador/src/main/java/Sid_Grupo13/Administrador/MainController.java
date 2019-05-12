package Sid_Grupo13.Administrador;

import java.net.URL;
import java.util.ResourceBundle;

import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Paint;

public class MainController implements Initializable {

	public Button showVariables;
	public Button showUsers;

	public TableView<Variable> variablesTable;
	public TableView<User> usersTable;

	public VBox variablesPane;
	public VBox usersPane;

	public void initialize(URL location, ResourceBundle resources) {
		setUpVariablesTable();
		setUpUsersTable();
		showVariables();
	}

	@SuppressWarnings("unchecked")
	private void setUpVariablesTable() {
		TableColumn<Variable, Integer> idColumn = new TableColumn<Variable, Integer>("ID");
		idColumn.setMinWidth(150);
		idColumn.setCellValueFactory(new PropertyValueFactory<Variable, Integer>("id"));

		TableColumn<Variable, String> nameColumn = new TableColumn<Variable, String>("Nome");
		nameColumn.setMinWidth(310);
		nameColumn.setCellValueFactory(new PropertyValueFactory<Variable, String>("name"));

		variablesTable.getColumns().addAll(idColumn, nameColumn);
	}

	@SuppressWarnings("unchecked")
	private void setUpUsersTable() {
		TableColumn<User, String> emailColumn = new TableColumn<User, String>("Email");
		emailColumn.setMinWidth(150);
		emailColumn.setCellValueFactory(new PropertyValueFactory<User, String>("email"));

		TableColumn<User, String> nameColumn = new TableColumn<User, String>("Nome");
		nameColumn.setMinWidth(150);
		nameColumn.setCellValueFactory(new PropertyValueFactory<User, String>("nomeUtilizador"));

		TableColumn<User, String> categoriaColumn = new TableColumn<User, String>("Categoria Profissional");
		categoriaColumn.setMinWidth(150);
		categoriaColumn.setCellValueFactory(new PropertyValueFactory<User, String>("categoriaProfissional"));

		TableColumn<User, String> usernameColumn = new TableColumn<User, String>("Username");
		usernameColumn.setMinWidth(150);
		usernameColumn.setCellValueFactory(new PropertyValueFactory<User, String>("username"));

		usersTable.getColumns().addAll(emailColumn, nameColumn, categoriaColumn, usernameColumn);
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