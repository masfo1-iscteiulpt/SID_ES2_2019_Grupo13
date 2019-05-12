package Sid_Grupo13.Administrador;

import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ResourceBundle;

import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Paint;

public class MainController implements Initializable {

	private Connection connection;

	public Button showVariables;
	public Button showUsers;

	public PasswordField password;

	public TableView<Variable> variablesTable;
	public TableView<User> usersTable;

	public TextField email;
	public TextField name;
	public TextField categoria;
	public TextField username;

	public VBox createUser;
	public VBox variablesPane;
	public VBox usersPane;

	public void initialize(URL location, ResourceBundle resources) {
		connect();
		setUpVariablesTable();
		setUpUsersTable();
		populateTables();
		showVariables();
	}

	private void connect() {
		try {
			connection = DriverManager.getConnection("jdbc:mariadb://localhost:3306/teste3?user=root&password=123");
		} catch (SQLException e) {
			e.printStackTrace();
		}
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

	private void populateTables() {
		usersTable.getItems().clear();
		try {
			PreparedStatement statement = connection.prepareStatement("SELECT * FROM utilizador;");
			ResultSet set = statement.executeQuery();
			while (set.next())
				usersTable.getItems()
						.add(new User(set.getString(1), set.getString(2), set.getString(3), set.getString(4)));
			statement.execute();
		} catch (SQLException e) {
			e.printStackTrace();
		}
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

	public void createUser() {
		createUser.toFront();
	}

	public void addUser() {
		try {
			String e = "\"" + email.getText() + "\", ";
			String n = "\"" + name.getText() + "\", ";
			String c = "\"" + categoria.getText() + "\", ";
			String u = "\"" + username.getText() + "\", ";
			String p = "\"" + password.getText() + "\"";
			PreparedStatement statement = connection
					.prepareStatement("CALL cria_utilizador(" + e + n + c + u + p + ");");
			statement.execute();
			populateTables();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		cancelUser();
	}

	public void cancelUser() {
		email.clear();
		name.clear();
		categoria.clear();
		username.clear();
		password.clear();
		createUser.toBack();
	}
}