package org.joonzis.domain;

import java.sql.Date;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BoardVO {
	private long bno;
	private String title, content, writer;
	private Date regdate, updatedate;
	private int replycnt;
	
	// 등록할 때 BoardAttachVO를 처리하도록 List 추가
	private List<BoardAttachVO> attachList;
}
