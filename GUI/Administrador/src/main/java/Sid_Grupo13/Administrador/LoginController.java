package Sid_Grupo13.Administrador;

import java.io.IOException;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

public class LoginController {

	@FXML
	private void login(ActionEvent actionEvent) throws IOException {
		Stage stage = new Stage();
		FXMLLoader loader = new FXMLLoader();
		loader.setController(new MainController());
		loader.setLocation(getClass().getResource("Main.fxml"));
		Parent root = loader.load();

		stage.setTitle("Culturas");
		stage.setMinHeight(480);
		stage.setMinWidth(680);
//		stage.setResizable(false);

		stage.setScene(new Scene(root));
		((Stage) ((Node) actionEvent.getSource()).getScene().getWindow()).close();
		stage.show();
		root.requestFocus();
	}
}