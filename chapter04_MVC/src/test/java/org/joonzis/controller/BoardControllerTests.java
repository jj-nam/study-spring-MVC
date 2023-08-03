package org.joonzis.controller;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@WebAppConfiguration
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({ "file:src/main/webapp/WEB-INF/spring/root-context.xml",
		"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml" })
public class BoardControllerTests {

	@Setter(onMethod_ = @Autowired)
	private WebApplicationContext ctx;

	// 가짜 MVC (가상으로 URL과 파라미터 등을 브라우저에서 사용하는 것처럼 실행 가능)
	private MockMvc mockMvc;

	@Before
	public void setup() {
		this.mockMvc = MockMvcBuilders.webAppContextSetup(ctx).build();
	}

	@Test
	public void testList() throws Exception {
		log.info(
				mockMvc.perform(MockMvcRequestBuilders.get("/board/list"))
				.andReturn().getModelAndView().getModelMap());
	}

	@Test
	public void testRegister() throws Exception {
		String result = mockMvc
				.perform(MockMvcRequestBuilders.post("/board/register")
						.param("title", "테스트 새 제목")
						.param("content", "테스트 새 내용")
						.param("writer", "테스트 새 작성자"))
				.andReturn().getModelAndView().getViewName();

		log.info(result);
	}

	@Test
	public void testGet() throws Exception {
		log.info(mockMvc.perform(MockMvcRequestBuilders.get("/board/get")
				.param("bno", "24"))
				.andReturn().getModelAndView().getModelMap());
	}

	@Test
	public void testModify() throws Exception {
		String result = mockMvc
				.perform(MockMvcRequestBuilders.post("/board/modify")
						.param("bno", "3")
						.param("title", "테스트 수정 제목2")
						.param("content", "테스트 수정 내용2")
						.param("writer", "테스트 수정 작성자2"))
				.andReturn().getModelAndView().getViewName();

		log.info(result);
	}

	@Test
	public void testRemove() throws Exception {
		String result = mockMvc.perform(MockMvcRequestBuilders.post("/board/remove")
				.param("bno", "21"))
				.andReturn().getModelAndView().getViewName();
		log.info(result);
	}

}
