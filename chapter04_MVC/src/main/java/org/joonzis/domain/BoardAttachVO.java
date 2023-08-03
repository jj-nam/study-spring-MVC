package org.joonzis.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BoardAttachVO {
	private String uuid, uploadPath, fileName;
	private boolean fileType;
	private long bno;
}
