package Sid_Grupo13.Monitorizador;

import static org.junit.Assert.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.Test;

import Sid_Grupo13.Monitorizador.models.Leitura;

public class LeituraTest {
	@Test
	public void test() {
		Leitura l=new Leitura(1.0,"test","test",1);
		Leitura l2=new Leitura(1.0,"test","test",1,1);
		assertNotNull(l.getTmp());
		assertEquals("test",l.getTim());
		assertEquals("test",l.getDat());
		assert(1==l.getCell());
		assert(1==l2.getId());
		l.toMongoString(1);
		l2.toMongoStringCurrentID();
	}
}
