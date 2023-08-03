package org.joonzis.controller;

import java.util.List;

import org.joonzis.domain.ReplyVO;
import org.joonzis.service.ReplyService;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@RestController
@RequestMapping("/replies/*")
@AllArgsConstructor
public class ReplyController {
	/*
	    * 동작에 따른 url 방법(http 전송 방식)
	    * 1. 등록 - /replies/new - POST
	    * 2. 페이지 - /replies/pages/:bno/:page - GET
	    * 3. 조회 - /replies/:rno - GET
	    * 4. 삭제 - /replies/:rno - DELETE
	    * 5. 수정 - /replies/:rno - PUT or PATCH
	    * 
	    * == REST 방식으로 설계할 땐 PK 기준으로 작성하는 것이 좋다. PK 만으로 CRUD가 가능하기 때문
	    * == 다만 댓글 목록은 PK 만으론 안되고 bno와 페이지 번호 정보가 필요
	*/
	
	private ReplyService service;
	
	// 1. 등록
	// consume = 수신 데이터 포맷 (insert와 update는 데이터를 입력하면 그 정보를 받기 때문에 사용)
	// produces = 송신 데이터 포맷 (view에서 produces로 요청 (전달 할 데이터))
	@PostMapping(value = "/new", consumes = "application/json; charset=utf-8", 
								produces = MediaType.TEXT_PLAIN_VALUE)
	public ResponseEntity<String> create(@RequestBody ReplyVO rvo){
		log.info("ReplyVO...." + rvo);
		
		int insertCount = service.register(rvo);
		
		log.info("Reply Insert Count : " + insertCount);
		
		return insertCount == 1 ?
				new ResponseEntity<>("success", HttpStatus.OK) : 
					new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	// 2. 목록
	@GetMapping(value = "/pages/{bno}/{page}",
			produces = {MediaType.APPLICATION_XML_VALUE,
					MediaType.APPLICATION_JSON_VALUE})
	public ResponseEntity<List<ReplyVO>> getList(@PathVariable("bno") long bno,
												@PathVariable("page") int page){
		log.info("getList...");
		
		return new ResponseEntity<>(service.getList(bno),HttpStatus.OK);
	}
	
	// 3. 조회
	// <VO>는 APPLICATION_XML_VALUE, APPLICATION_JSON_VALUE로 받는게 좋다.
	@GetMapping(value = "/{rno}", produces = {MediaType.APPLICATION_XML_VALUE,
											MediaType.APPLICATION_JSON_VALUE})
	public ResponseEntity<ReplyVO> get(@PathVariable("rno") long rno){
		log.info("get..." + rno);
		
		return new ResponseEntity<>(service.get(rno),HttpStatus.OK);
	}
	
	// 4. 삭제
	// <String>으로 받기 때문에 produces는 TEXT_PLAIN_VALUE로 받는게 좋다
	@DeleteMapping(value = "/{rno}", produces = MediaType.TEXT_PLAIN_VALUE)
	public ResponseEntity<String> remove(@PathVariable("rno") long rno){
		log.info("remove..." + rno);
		
		return service.remove(rno) == 1 ?
				new ResponseEntity<>("success", HttpStatus.OK) : 
					new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@DeleteMapping(value = "/remove/{bno}", produces = MediaType.TEXT_PLAIN_VALUE)
	public ResponseEntity<String> removeAll(@PathVariable("bno") long bno){
		log.info("removeAll..." + bno);
		
		return service.removeAll(bno) > 0 ?
				new ResponseEntity<>("success", HttpStatus.OK) : 
					new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	
	// 5. 수정
	// 수정은 mapping명이 따로 없어서 RequestMapping을 사용하고 method에 입력
	@RequestMapping(value ="/{rno}", method = {RequestMethod.PUT, RequestMethod.PATCH},
									produces = MediaType.TEXT_PLAIN_VALUE,
									consumes = "application/json")
	public ResponseEntity<String> modify(@PathVariable("rno") long rno, 
										 @RequestBody ReplyVO rvo){
		log.info("Modify...." + rvo);
		log.info("rno...." + rno);
		
		rvo.setRno(rno);
		
		int modifyCount = service.modify(rvo);
		
		log.info("Reply Modify Count : " + modifyCount);
		
		return modifyCount == 1 ?
				new ResponseEntity<>("success", HttpStatus.OK) : 
					new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
}
