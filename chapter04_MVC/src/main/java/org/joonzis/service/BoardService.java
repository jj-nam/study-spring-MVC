package org.joonzis.service;

import java.util.List;

import org.joonzis.domain.BoardAttachVO;
import org.joonzis.domain.BoardVO;
import org.joonzis.domain.Criteria;

public interface BoardService {
	public List<BoardVO> getList(Criteria cri);
	public void register(BoardVO vo);
	public BoardVO get(long bno);
	public boolean remove(long bno);
	public boolean modify(BoardVO vo);
	public int getTotal();
	public List<BoardAttachVO> getAttachList(long bno);
	public BoardAttachVO getBoardVO(long bno);
}
