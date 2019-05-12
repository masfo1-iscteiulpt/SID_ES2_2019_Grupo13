package Sid_Grupo13.Administrador;

public class User {

	private String email;
	private String nomeUtilizador;
	private String categoriaProfissional;
	private String username;

	public User(String email, String nomeUtilizador, String categoriaProfissional, String username) {
		this.email = email;
		this.nomeUtilizador = nomeUtilizador;
		this.categoriaProfissional = categoriaProfissional;
		this.username = username;
	}

	public String getEmail() {
		return email;
	}

	public String getNomeUtilizador() {
		return nomeUtilizador;
	}

	public String getCategoriaProfissional() {
		return categoriaProfissional;
	}

	public String getUsername() {
		return username;
	}
}