package org.joonzis.domain;

import java.util.Date;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class MemberVO {
	private String userid, userpw, username;
	private Date regdate, updatedate;
	private boolean enaled;
	
	private List<AuthVO> authList;
}
