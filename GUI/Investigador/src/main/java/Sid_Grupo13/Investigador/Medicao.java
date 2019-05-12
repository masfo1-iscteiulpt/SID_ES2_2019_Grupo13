package Sid_Grupo13.Investigador;

import java.sql.Timestamp;

public class Medicao {

	private int id;
	private Timestamp datahora;
	private double valor;
	private int idCultura;
	private int idVariavel;

	public Medicao(int id, Timestamp datahora, double valor, int idCultura, int idVariavel) {
		this.id = id;
		this.datahora = datahora;
		this.valor = valor;
		this.idCultura = idCultura;
		this.idVariavel = idVariavel;
	}

	public int getId() {
		return id;
	}

	public Timestamp getDatahora() {
		return datahora;
	}

	public double getValor() {
		return valor;
	}

	public int getIdCultura() {
		return idCultura;
	}

	public int getIdVariavel() {
		return idVariavel;
	}
}