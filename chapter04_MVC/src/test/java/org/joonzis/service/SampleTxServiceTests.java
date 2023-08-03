package org.joonzis.service;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.extern.log4j.Log4j;

@Log4j
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class SampleTxServiceTests {
	@Autowired
	private SampleTxService service;
	
	@Test
	public void test() {
		String str = "동해 물과 백두산이 마르고 닳도록\r\n"
	            + "하느님이 보호하사 우리나라 만세"
	            + "남산 위에 저 소나무 철갑을 두른 듯\r\n"
	            + "바람 서리 불변함은 우리 기상일세"
	            + "가을 하늘 공활한데 높고 구름 없이\r\n"
	            + "밝은 달은 우리가슴 일편단심일세"
	            + "이 기상과 이 맘으로 충성을 다하여\r\n"
	            + "괴로우나 즐거우나 나라사랑하세";
		
		log.info(str.getBytes().length);
		service.addData(str);
	}
}
