package Sid_Grupo13.Investigador;

import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ResourceBundle;

import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Paint;

public class MainController implements Initializable {

	private Connection connection;

	public Button showCulturas;
	public Button showMedicoes;

	public TableView<Cultura> culturasTable;
	public TableView<Medicao> medicoesTable;

	public VBox culturasPane;
	public VBox medicoesPane;

	public void initialize(URL location, ResourceBundle resources) {
		connect();
		setUpCulturasTable();
		setUpMedicoesTable();
//		populateUsers();
//		populateVariables();
		showCulturas();
	}

	private void connect() {
		try {
			connection = DriverManager.getConnection("jdbc:mariadb://localhost:3306/teste3?user=root&password=123");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@SuppressWarnings("unchecked")
	private void setUpCulturasTable() {
		TableColumn<Cultura, Integer> idColumn = new TableColumn<Cultura, Integer>("ID");
		idColumn.setMinWidth(150);
		idColumn.setCellValueFactory(new PropertyValueFactory<Cultura, Integer>("id"));

		TableColumn<Cultura, String> nameColumn = new TableColumn<Cultura, String>("Nome");
		nameColumn.setMinWidth(310);
		nameColumn.setCellValueFactory(new PropertyValueFactory<Cultura, String>("nome"));

		TableColumn<Cultura, String> descricaoColumn = new TableColumn<Cultura, String>("Descrição");
		descricaoColumn.setMinWidth(310);
		descricaoColumn.setCellValueFactory(new PropertyValueFactory<Cultura, String>("descricao"));

		TableColumn<Cultura, String> usernameColumn = new TableColumn<Cultura, String>("Username");
		usernameColumn.setMinWidth(310);
		usernameColumn.setCellValueFactory(new PropertyValueFactory<Cultura, String>("username"));

		culturasTable.getColumns().addAll(idColumn, nameColumn, descricaoColumn, usernameColumn);
	}

	@SuppressWarnings("unchecked")
	private void setUpMedicoesTable() {
		TableColumn<Medicao, Integer> idColumn = new TableColumn<Medicao, Integer>("ID");
		idColumn.setMinWidth(150);
		idColumn.setCellValueFactory(new PropertyValueFactory<Medicao, Integer>("id"));

		TableColumn<Medicao, Timestamp> dataColumn = new TableColumn<Medicao, Timestamp>("Datahora");
		dataColumn.setMinWidth(150);
		dataColumn.setCellValueFactory(new PropertyValueFactory<Medicao, Timestamp>("datahora"));

		TableColumn<Medicao, Double> valorColumn = new TableColumn<Medicao, Double>("Valor");
		valorColumn.setMinWidth(150);
		valorColumn.setCellValueFactory(new PropertyValueFactory<Medicao, Double>("valor"));

		TableColumn<Medicao, Integer> idCulturaColumn = new TableColumn<Medicao, Integer>("Cultura");
		idCulturaColumn.setMinWidth(150);
		idCulturaColumn.setCellValueFactory(new PropertyValueFactory<Medicao, Integer>("idCultura"));

		TableColumn<Medicao, Integer> idVariavelColumn = new TableColumn<Medicao, Integer>("Variavel");
		idVariavelColumn.setMinWidth(150);
		idVariavelColumn.setCellValueFactory(new PropertyValueFactory<Medicao, Integer>("idVariavel"));

		medicoesTable.getColumns().addAll(idColumn, dataColumn, valorColumn, idCulturaColumn, idVariavelColumn);
	}

	public void showCulturas() {
		showCulturas.setStyle("-fx-background-color: #ffffff");
		showCulturas.setTextFill(Paint.valueOf("#000000"));
		showMedicoes.setStyle("-fx-background-color: #05BC78");
		showMedicoes.setTextFill(Paint.valueOf("#ffffff"));
		culturasPane.toFront();
	}

	public void showMedicoes() {
		showMedicoes.setStyle("-fx-background-color: #ffffff");
		showMedicoes.setTextFill(Paint.valueOf("#000000"));
		showCulturas.setStyle("-fx-background-color: #05BC78");
		showCulturas.setTextFill(Paint.valueOf("#ffffff"));
		medicoesPane.toFront();
	}
}