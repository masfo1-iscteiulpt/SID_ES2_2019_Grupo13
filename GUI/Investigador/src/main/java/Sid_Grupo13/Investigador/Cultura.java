package Sid_Grupo13.Investigador;

public class Cultura {

	private int id;
	private String nome;
	private String descricao;
	private String username;
	
	public Cultura(int id, String nome, String descricao, String username) {
		this.id = id;
		this.nome = nome;
		this.descricao = descricao;
		this.username = username;
	}

	public int getId() {
		return id;
	}

	public String getNome() {
		return nome;
	}

	public String getDescricao() {
		return descricao;
	}

	public String getUsername() {
		return username;
	}
}