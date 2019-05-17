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
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Paint;

public class MainController implements Initializable {

	private Connection connection;
	private int selectedCultura;
	private int selectedLimitVar;
	private int selectedLimitCul;
	private int selectedMedicao;
	private boolean extraLimite;

	public Button showCulturas;
	public Button showMedicoes;
	public Button showLimites;

	public TableView<Cultura> culturasTable;
	public TableView<Medicao> medicoesTable;
	public TableView<Limite> limitesTable;

	public VBox culturasPane;
	public VBox medicoesPane;
	public VBox limitesPane;
	public VBox createCultura;
	public VBox alterCultura;
	public VBox createMedicao;
	public VBox createLimite;
	public VBox alterLimite;
	public VBox alterMedicao;

	public TextField culturaName;
	public TextField culturaDescricao;
	public TextField alterNameCultura;
	public TextField alterDescricaoCultura;
	public TextField medicaoValor;
	public TextField alterMedicaoValor;
	public TextField limiteInferior;
	public TextField limiteSuperior;
	public TextField limiteInferiorAlter;
	public TextField limiteSuperiorAlter;
	public TextField limiteMargem;
	public TextField limiteMargemAlter;

	public ChoiceBox<String> medicaoCultura;
	public ChoiceBox<String> medicaoVariavel;
	public ChoiceBox<String> limiteCultura;
	public ChoiceBox<String> limiteVariavel;

	public MainController(Connection connection) {
		this.connection = connection;
	}

	public void initialize(URL location, ResourceBundle resources) {
		limiteCultura.valueProperty().addListener((v, oldValue, newValue) -> {
			limiteVariavel.getItems().clear();
			limiteVariavel.setDisable(true);
			if (newValue != null)
				if (!newValue.isEmpty())
					try {
						String c = newValue.split(" - ")[0];
						PreparedStatement statement = connection
								.prepareStatement("CALL select_v_disponiveis(" + c + ")");
						ResultSet result = statement.executeQuery();

						if (result.next()) {
							do {
								limiteVariavel.getItems().add(result.getInt(1) + " - " + result.getString(2));
							} while (result.next());
							limiteVariavel.setDisable(false);
						}
					} catch (SQLException e) {
						e.printStackTrace();
					}
		});
		setUpCulturasTable();
		setUpMedicoesTable();
		setUpLimitesTable();
		populateCulturas();
		populateMedicoes();
		populateLimites();
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

		TableColumn<Medicao, String> idCulturaColumn = new TableColumn<Medicao, String>("Cultura");
		idCulturaColumn.setMinWidth(90);
		idCulturaColumn.setCellValueFactory(new PropertyValueFactory<Medicao, String>("culturaName"));

		TableColumn<Medicao, String> idVariavelColumn = new TableColumn<Medicao, String>("Variavel");
		idVariavelColumn.setMinWidth(90);
		idVariavelColumn.setCellValueFactory(new PropertyValueFactory<Medicao, String>("variavelName"));

		medicoesTable.getColumns().addAll(idColumn, dataColumn, valorColumn, idCulturaColumn, idVariavelColumn);
	}

	@SuppressWarnings("unchecked")
	public void setUpLimitesTable() {
		TableColumn<Limite, Double> infColumn = new TableColumn<Limite, Double>("Limite inferior");
		infColumn.setMinWidth(90);
		infColumn.setCellValueFactory(new PropertyValueFactory<Limite, Double>("limiteInferior"));

		TableColumn<Limite, Double> supColumn = new TableColumn<Limite, Double>("Limite superior");
		supColumn.setMinWidth(90);
		supColumn.setCellValueFactory(new PropertyValueFactory<Limite, Double>("limiteSuperior"));

		TableColumn<Limite, String> varColumn = new TableColumn<Limite, String>("Nome variável");
		varColumn.setMinWidth(90);
		varColumn.setCellValueFactory(new PropertyValueFactory<Limite, String>("variavelName"));

		TableColumn<Limite, String> culColumn = new TableColumn<Limite, String>("Nome cultura");
		culColumn.setMinWidth(90);
		culColumn.setCellValueFactory(new PropertyValueFactory<Limite, String>("culturaName"));

		TableColumn<Limite, Integer> margemColumn = new TableColumn<Limite, Integer>("Margem");
		margemColumn.setMinWidth(90);
		margemColumn.setCellValueFactory(new PropertyValueFactory<Limite, Integer>("margem"));

		limitesTable.getColumns().addAll(infColumn, supColumn, varColumn, culColumn, margemColumn);
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

	public void populateMedicoes() {
		medicoesTable.getItems().clear();
		try {
			PreparedStatement statement = connection.prepareStatement("CALL select_medicoes();");
			ResultSet set = statement.executeQuery();
			while (set.next())
				medicoesTable.getItems().add(new Medicao(set.getInt(1), set.getTimestamp(2), set.getDouble(3),
						set.getInt(4), set.getInt(5), set.getString(6), set.getString(7)));
			statement.execute();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void populateLimites() {
		limitesTable.getItems().clear();
		try {
			PreparedStatement statement = connection.prepareStatement("CALL select_limites();");
			ResultSet set = statement.executeQuery();
			while (set.next())
				limitesTable.getItems().add(new Limite(set.getDouble(1), set.getDouble(2), set.getInt(3), set.getInt(4),
						set.getInt(5), set.getString(6), set.getString(7)));
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
		showLimites.setStyle("-fx-background-color: #05BC78");
		showLimites.setTextFill(Paint.valueOf("#ffffff"));
		culturasPane.toFront();
	}

	public void showMedicoes() {
		showMedicoes.setStyle("-fx-background-color: #ffffff");
		showMedicoes.setTextFill(Paint.valueOf("#000000"));
		showCulturas.setStyle("-fx-background-color: #05BC78");
		showCulturas.setTextFill(Paint.valueOf("#ffffff"));
		showLimites.setStyle("-fx-background-color: #05BC78");
		showLimites.setTextFill(Paint.valueOf("#ffffff"));
		medicoesPane.toFront();
	}

	public void showLimites() {
		showLimites.setStyle("-fx-background-color: #ffffff");
		showLimites.setTextFill(Paint.valueOf("#000000"));
		showMedicoes.setStyle("-fx-background-color: #05BC78");
		showMedicoes.setTextFill(Paint.valueOf("#ffffff"));
		showCulturas.setStyle("-fx-background-color: #05BC78");
		showCulturas.setTextFill(Paint.valueOf("#ffffff"));
		limitesPane.toFront();
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
		medicaoCultura.getItems().clear();
		medicaoVariavel.getItems().clear();
		try {
			PreparedStatement statement = connection.prepareStatement("CALL select_culturas();");
			ResultSet result = statement.executeQuery();

			while (result.next())
				medicaoCultura.getItems().add(result.getInt(1) + " - " + result.getString(2));

			statement = connection.prepareStatement("SELECT * FROM variavel;");
			result = statement.executeQuery();

			while (result.next())
				medicaoVariavel.getItems().add(result.getInt(1) + " - " + result.getString(2));
		} catch (SQLException e) {
			e.printStackTrace();
		}

		createMedicao.toFront();
	}

	public void createMedicao() {
		try {
			String c = medicaoCultura.getValue().split(" - ")[0];
			String var = medicaoVariavel.getValue().split(" - ")[0];

			PreparedStatement check = connection
					.prepareStatement("SELECT * FROM `variaveis_medidas` WHERE Variavel_IDVariavel=" + var
							+ " AND Cultura_IDCultura=" + c + ";");
			ResultSet result = check.executeQuery();

			if (!result.next()) {
				extraLimite = true;
//				openCreateLimite();
				limiteCultura.getItems().add(medicaoCultura.getValue());
				limiteCultura.setValue(medicaoCultura.getValue());
				limiteCultura.setDisable(true);
				limiteVariavel.getItems().add(medicaoVariavel.getValue());
				limiteVariavel.setValue(medicaoVariavel.getValue());
				limiteVariavel.setDisable(true);

				createLimite.toFront();
			} else {
				addMedicao();
				cancelCreateMedicao();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	private void addMedicao() {
		try {
			if (!medicaoValor.getText().isEmpty() && !medicaoCultura.getValue().isEmpty()
					&& !medicaoVariavel.getValue().isEmpty()) {
				String v = medicaoValor.getText() + ", ";
				String c = medicaoCultura.getValue().split(" - ")[0];
				String var = medicaoVariavel.getValue().split(" - ")[0];

				PreparedStatement statement = connection
						.prepareStatement("INSERT INTO `medicao` VALUES (null, now(), " + v + c + ", " + var + ");");

				statement.execute();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		populateMedicoes();
	}

	public void cancelCreateMedicao() {
		medicaoValor.clear();
		medicaoCultura.setValue("");
		medicaoVariavel.setValue("");

		createMedicao.toBack();
	}

	public void openAlterMedicao() {
		ObservableList<Medicao> selected = medicoesTable.getSelectionModel().getSelectedItems();

		if (selected.size() > 0) {
			Medicao medicao = selected.get(0);
			selectedMedicao = medicao.getId();

			alterMedicaoValor.setText(medicao.getValor() + "");

			alterMedicao.toFront();
		}
	}

	public void alterMedicao() {
		try {
			if (!alterMedicaoValor.getText().isEmpty()) {
				String v = alterMedicaoValor.getText();
				PreparedStatement statement = connection.prepareStatement(
						"UPDATE `medicao` SET `ValorMedicao`=" + v + " WHERE `NumeroMedicao`=" + selectedMedicao + ";");
				statement.execute();
				populateMedicoes();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		cancelAlterMedicao();
	}

	public void cancelAlterMedicao() {
		alterMedicaoValor.clear();

		alterMedicao.toBack();
	}

	public void deleteMedicao() {
		ObservableList<Medicao> all = medicoesTable.getItems();
		ObservableList<Medicao> selected = medicoesTable.getSelectionModel().getSelectedItems();

		for (Medicao medicao : selected) {
			try {
				PreparedStatement statement = connection
						.prepareStatement("DELETE FROM `medicao` WHERE `NumeroMedicao`=" + medicao.getId() + ";");
				statement.execute();
				all.remove(medicao);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	public void openCreateLimite() {
		limiteCultura.setDisable(false);
		limiteVariavel.setDisable(true);
		limiteCultura.getItems().clear();
		limiteVariavel.getItems().clear();
		try {
			PreparedStatement statement = connection.prepareStatement("CALL select_culturas();");
			ResultSet result = statement.executeQuery();

			while (result.next())
				limiteCultura.getItems().add(result.getInt(1) + " - " + result.getString(2));
		} catch (SQLException e) {
			e.printStackTrace();
		}

		createLimite.toFront();
	}

	public void createLimite() {
		try {
			if (!limiteCultura.getValue().isEmpty() && !limiteVariavel.getValue().isEmpty()
					&& !limiteSuperior.getText().isEmpty() && !limiteInferior.getText().isEmpty()
					&& !limiteMargem.getText().isEmpty()) {
				String c = limiteCultura.getValue().split(" - ")[0] + ", ";
				String v = limiteVariavel.getValue().split(" - ")[0] + ", ";
				String ls = limiteSuperior.getText() + ", ";
				String li = limiteInferior.getText() + ", ";
				String m = limiteMargem.getText();
				PreparedStatement statement = connection
						.prepareStatement("CALL cria_variaveis_medidas(" + c + v + ls + li + m + ");");
				statement.execute();
				System.out.println(statement.toString());
				populateLimites();

				if (extraLimite) {
					addMedicao();
					cancelCreateMedicao();
					extraLimite = false;
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		cancelCreateLimite();
	}

	public void cancelCreateLimite() {
		limiteInferior.clear();
		limiteSuperior.clear();
		limiteCultura.setValue("");
		limiteVariavel.setValue("");
		limiteMargem.clear();

		createLimite.toBack();
	}

	public void showAlterLimite() {
		ObservableList<Limite> selected = limitesTable.getSelectionModel().getSelectedItems();

		if (selected.size() > 0) {
			Limite limite = selected.get(0);
			selectedLimitVar = limite.getVariavel();
			selectedLimitCul = limite.getCultura();

			limiteInferiorAlter.setText(limite.getLimiteInferior() + "");
			limiteSuperiorAlter.setText(limite.getLimiteSuperior() + "");
			limiteMargemAlter.setText(limite.getMargem() + "");

			alterLimite.toFront();
		}
	}

	public void alterLimite() {
		try {
			if (!limiteInferiorAlter.getText().isEmpty() && !limiteSuperiorAlter.getText().isEmpty()
					&& !limiteMargemAlter.getText().isEmpty()) {
				String li = limiteInferiorAlter.getText();
				String ls = limiteSuperiorAlter.getText();
				String m = limiteMargemAlter.getText();
				PreparedStatement statement = connection
						.prepareStatement("UPDATE `variaveis_medidas` SET `LimiteInferior`=" + li
								+ ", `LimiteSuperior`=" + ls + ", `Margem`=" + m + " WHERE Variavel_IDVariavel="
								+ selectedLimitVar + " AND Cultura_IDCultura=" + selectedLimitCul + ";");
				statement.execute();
				populateLimites();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		cancelAlterLimite();
	}

	public void cancelAlterLimite() {
		limiteInferiorAlter.clear();
		limiteSuperiorAlter.clear();
		limiteMargemAlter.clear();

		alterLimite.toBack();
	}

	public void deleteLimite() {
		ObservableList<Limite> all = limitesTable.getItems();
		ObservableList<Limite> selected = limitesTable.getSelectionModel().getSelectedItems();

		for (Limite limite : selected) {
			try {
				PreparedStatement statement = connection.prepareStatement(
						"CALL apaga_variavel_medida(" + limite.getVariavel() + ", " + limite.getCultura() + ");");
				statement.execute();
				all.remove(limite);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
}