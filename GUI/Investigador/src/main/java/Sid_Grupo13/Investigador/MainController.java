package Sid_Grupo13.Investigador;

import java.net.URL;
import java.util.ResourceBundle;

import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.TableView;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Paint;

public class MainController implements Initializable {

	public Button showCulturas;
	public Button showMedicoes;

	public TableView<Cultura> culturasTable;
	public TableView<Medicao> medicoesTable;

	public VBox culturasPane;
	public VBox medicoesPane;

	public void initialize(URL location, ResourceBundle resources) {
		showCulturas();
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