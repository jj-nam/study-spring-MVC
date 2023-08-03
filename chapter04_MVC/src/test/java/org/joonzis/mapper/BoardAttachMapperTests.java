package org.joonzis.mapper;

import java.util.List;

import org.joonzis.domain.BoardAttachVO;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class BoardAttachMapperTests {

	@Setter(onMethod_ = @Autowired)
	BoardAttachMapper amapper;
	@Test
	public void testInsert() {
		BoardAttachVO vo = new BoardAttachVO();
		
		vo.setUuid("12345");
		vo.setUploadPath("C:\\upload\\2023\\07\\10");
		vo.setFileName("테스트");
		vo.setBno(84);
		
		amapper.insert(vo);
	}
	@Test
	public void testDelete() {
		amapper.delete("123");
	}
	@Test
	public void testFindByBno() {
		List<BoardAttachVO> list = amapper.findByBno(84); 
		for (BoardAttachVO vo : list) { 
			amapper.findByBno(84); 
			}
	}
	
}
