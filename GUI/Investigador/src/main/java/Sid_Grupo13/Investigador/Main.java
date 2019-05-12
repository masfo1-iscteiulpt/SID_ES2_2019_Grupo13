package Sid_Grupo13.Investigador;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

public class Main extends Application {

	public static void main(String[] args) {
		launch(args);
	}

	@Override
	public void start(Stage primaryStage) throws Exception {
		FXMLLoader loader = new FXMLLoader();
		loader.setController(new LoginController());
		loader.setLocation(getClass().getResource("Login.fxml"));
		Parent root = loader.load();

		primaryStage.setTitle("Culturas");
		primaryStage.setMinHeight(490);
		primaryStage.setMinWidth(370);

		primaryStage.setScene(new Scene(root));
		primaryStage.show();
		root.requestFocus();
	}
}