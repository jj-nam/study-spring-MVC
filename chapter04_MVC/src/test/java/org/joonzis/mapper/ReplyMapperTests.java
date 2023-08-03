package org.joonzis.mapper;

import java.util.List;

import org.joonzis.domain.ReplyVO;
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
public class ReplyMapperTests {

	@Setter(onMethod_ = @Autowired)
	ReplyMapper rmapper;

	@Test
	public void testGetList() {
		List<ReplyVO> list = rmapper.getList(81);
		for (ReplyVO rvo : list) {
			log.info(rvo);
		}
	}

	@Test
	public void testInsert() {
		ReplyVO rvo = new ReplyVO();

		rvo.setBno(81);
		rvo.setReply("오늘의 저녁은??");
		rvo.setReplyer("작성자");

		rmapper.insert(rvo);
		log.info(rvo);
	}

	@Test
	public void testRead() {
		log.info(rmapper.read(2));
	}

	@Test
	public void testDelete() {
		rmapper.delete(1);
	}

	@Test
	public void testUpdate() {
		ReplyVO rvo = new ReplyVO();

		rvo.setRno(2);
		rvo.setReply("샐러드");
		rvo.setReplyer("요리사");

		rmapper.update(rvo);
	}

}
