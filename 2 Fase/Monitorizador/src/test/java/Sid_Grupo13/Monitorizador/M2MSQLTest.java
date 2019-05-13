package Sid_Grupo13.Monitorizador;

import java.text.ParseException;

import org.junit.Test;

public class M2MSQLTest {
	@Test
	public void test() throws InterruptedException, ParseException {
		MongoToMySql.main(new String [2]);
	}
}
