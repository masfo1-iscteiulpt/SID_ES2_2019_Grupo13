package Sid_Grupo13.Monitorizador.models;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonIgnoreProperties(ignoreUnknown = true)
public class Leitura {
	
	@JsonProperty(required=true)
	private Double tmp;
	private String tim;
	private String dat;
	private Integer cell;
	
	public Double getTmp() {
		return tmp;
	}
	public void setTmp(Double tmp) {
		this.tmp = tmp;
	}
	public String getTim() {
		return tim;
	}
	public void setTim(String tim) {
		this.tim = tim;
	}
	public String getDat() {
		return dat;
	}
	public void setDat(String dat) {
		this.dat = dat;
	}
	public Integer getCell() {
		return cell;
	}
	public void setCell(Integer cell) {
		this.cell = cell;
	}
	// dummy constructor
	public Leitura() {
		
	}
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