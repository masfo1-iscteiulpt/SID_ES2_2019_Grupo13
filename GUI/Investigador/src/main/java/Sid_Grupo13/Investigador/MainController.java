package Sid_Grupo13.Investigador;

import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ResourceBundle;

import javafx.collections.ObservableList;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Paint;

public class MainController implements Initializable {

	private Connection connection;
	private int selectedCultura;

	public Button showCulturas;
	public Button showMedicoes;

	public TableView<Cultura> culturasTable;
	public TableView<Medicao> medicoesTable;

	public VBox culturasPane;
	public VBox medicoesPane;
	public VBox createCultura;
	public VBox alterCultura;
	public VBox createMedicao;

	public TextField culturaName;
	public TextField culturaDescricao;
	public TextField alterNameCultura;
	public TextField alterDescricaoCultura;
	public TextField medicaoValor;
	public TextField medicaoCultura;
	public TextField medicaoVariavel;

	public MainController(Connection connection) {
		this.connection = connection;
	}

	public void initialize(URL location, ResourceBundle resources) {
		setUpCulturasTable();
		setUpMedicoesTable();
		populateCulturas();
//		populateVariables();
		showCulturas();
	}

	@SuppressWarnings("unchecked")
	private void setUpCulturasTable() {
		TableColumn<Cultura, Integer> idColumn = new TableColumn<Cultura, Integer>("ID");
		idColumn.setMinWidth(90);
		idColumn.setCellValueFactory(new PropertyValueFactory<Cultura, Integer>("id"));

		TableColumn<Cultura, String> nameColumn = new TableColumn<Cultura, String>("Nome");
		nameColumn.setMinWidth(90);
		nameColumn.setCellValueFactory(new PropertyValueFactory<Cultura, String>("nome"));

		TableColumn<Cultura, String> descricaoColumn = new TableColumn<Cultura, String>("Descrição");
		descricaoColumn.setMinWidth(90);
		descricaoColumn.setCellValueFactory(new PropertyValueFactory<Cultura, String>("descricao"));

		culturasTable.getColumns().addAll(idColumn, nameColumn, descricaoColumn);
	}

	@SuppressWarnings("unchecked")
	private void setUpMedicoesTable() {
		TableColumn<Medicao, Integer> idColumn = new TableColumn<Medicao, Integer>("ID");
		idColumn.setMinWidth(90);
		idColumn.setCellValueFactory(new PropertyValueFactory<Medicao, Integer>("id"));

		TableColumn<Medicao, Timestamp> dataColumn = new TableColumn<Medicao, Timestamp>("Datahora");
		dataColumn.setMinWidth(90);
		dataColumn.setCellValueFactory(new PropertyValueFactory<Medicao, Timestamp>("datahora"));

		TableColumn<Medicao, Double> valorColumn = new TableColumn<Medicao, Double>("Valor");
		valorColumn.setMinWidth(90);
		valorColumn.setCellValueFactory(new PropertyValueFactory<Medicao, Double>("valor"));

		TableColumn<Medicao, Integer> idCulturaColumn = new TableColumn<Medicao, Integer>("Cultura");
		idCulturaColumn.setMinWidth(90);
		idCulturaColumn.setCellValueFactory(new PropertyValueFactory<Medicao, Integer>("idCultura"));

		TableColumn<Medicao, Integer> idVariavelColumn = new TableColumn<Medicao, Integer>("Variavel");
		idVariavelColumn.setMinWidth(90);
		idVariavelColumn.setCellValueFactory(new PropertyValueFactory<Medicao, Integer>("idVariavel"));

		medicoesTable.getColumns().addAll(idColumn, dataColumn, valorColumn, idCulturaColumn, idVariavelColumn);
	}

	public void populateCulturas() {
		culturasTable.getItems().clear();
		try {
			PreparedStatement statement = connection.prepareStatement("CALL select_culturas();");
			ResultSet set = statement.executeQuery();
			while (set.next())
				culturasTable.getItems()
						.add(new Cultura(set.getInt(1), set.getString(2), set.getString(3), set.getString(4)));
			statement.execute();
		} catch (SQLException e) {
			e.printStackTrace();
		}
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

	public void openCreateCultura() {
		createCultura.toFront();
	}

	public void createCultura() {
		try {
			String n = "\"" + culturaName.getText() + "\", ";
			String d = "\"" + culturaDescricao.getText() + "\"";
			PreparedStatement statement = connection.prepareStatement("CALL cria_cultura(" + n + d + ");");
			statement.execute();
			populateCulturas();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		cancelCreateCultura();
	}

	public void cancelCreateCultura() {
		culturaName.clear();
		culturaDescricao.clear();

		createCultura.toBack();
	}

	public void showAlterCultura() {
		ObservableList<Cultura> selected = culturasTable.getSelectionModel().getSelectedItems();

		if (selected.size() > 0) {
			Cultura cultura = selected.get(0);
			selectedCultura = cultura.getId();

			alterNameCultura.setText(cultura.getNome());
			alterDescricaoCultura.setText(cultura.getDescricao());

			alterCultura.toFront();
		}
	}

	public void alterCultura() {
		try {
			String n = "\"" + alterNameCultura.getText() + "\"";
			String d = "\"" + alterDescricaoCultura.getText() + "\"";
			PreparedStatement statement = connection.prepareStatement("UPDATE `cultura` SET `NomeCultura`=" + n
					+ ", `DescricaoCultura`=" + d + " WHERE `IDcultura`=" + selectedCultura + ";");
			statement.execute();
			populateCulturas();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		cancelAlterCultura();
	}

	public void cancelAlterCultura() {
		alterNameCultura.clear();
		alterDescricaoCultura.clear();

		alterCultura.toBack();
	}

	public void deleteCultura() {
		ObservableList<Cultura> all = culturasTable.getItems();
		ObservableList<Cultura> selected = culturasTable.getSelectionModel().getSelectedItems();

		for (Cultura cultura : selected) {
			try {
				PreparedStatement statement = connection
						.prepareStatement("CALL apaga_cultura(" + cultura.getId() + ");");
				statement.execute();
				all.remove(cultura);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	public void openCreateMedicao() {
		createMedicao.toFront();
	}

	public void createMedicao() {
		try {
			String v = medicaoValor.getText() + ", ";
			String c = medicaoCultura.getText() + ", ";
			String var = medicaoVariavel.getText();
			PreparedStatement statement = connection.prepareStatement("CALL inserir_medicao(" + v + c + var + ");");
			statement.execute();
			populateCulturas();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		cancelCreateCultura();
	}
}