package Sid_Grupo13.Monitorizador;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Leitura {
	@JsonProperty(required=true)
	public Double tmp;
	public String tim;
	public String dat;
	public Integer cell;
	
	public Leitura(Double tmp,String tim,String dat,Integer cell) {
		this.tmp=tmp;
		this.tim=tim;
		this.dat=dat;
		this.cell=cell;
	}
	public boolean validate() {
		return (tmp!=null&&tim!=null&&dat!=null&&cell!=null);
	}
	public String toMongoString(int index) {
		return "{\"readid\":\""
				+index+
				"\",\"tmp\":\""
				+tmp+
				"\",\"dat\":\""
				+dat+
				"\",\"tim\":\""
				+tim+
				"\",\"cell\":\""
				+cell+
				"\"}";
	}
}
