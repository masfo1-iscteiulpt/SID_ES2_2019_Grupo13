package Sid_Grupo13.Investigador;

public class Limite {

	private double limiteInferior;
	private double limiteSuperior;
	private int cultura;
	private int variavel;
	private String culturaName;
	private String variavelName;

	public Limite(double limiteInferior, double limiteSuperior, int cultura, int variavel, String culturaName,
			String variavelName) {
		this.limiteInferior = limiteInferior;
		this.limiteSuperior = limiteSuperior;
		this.cultura = cultura;
		this.variavel = variavel;
		this.culturaName = culturaName;
		this.variavelName = variavelName;
	}

	public double getLimiteInferior() {
		return limiteInferior;
	}

	public double getLimiteSuperior() {
		return limiteSuperior;
	}

	public int getCultura() {
		return cultura;
	}

	public int getVariavel() {
		return variavel;
	}

	public String getCulturaName() {
		return culturaName;
	}

	public String getVariavelName() {
		return variavelName;
	}
}