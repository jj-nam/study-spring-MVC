package org.joonzis.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.joonzis.domain.BoardVO;
import org.joonzis.domain.Criteria;

public interface BoardMapper {
	/* public List<BoardVO> getList(); */
	public List<BoardVO> getListWithPaging(Criteria cri);
	public int insert(BoardVO vo);
	public BoardVO read(long bno);
	public int delete(long bno);
	public int update(BoardVO vo);
	public int getTotalcount();		// 전체 게시물 수
	// 두개 이상의 데이터를 보내주기 위해 @Param을 사용
	public void updateReplyCnt(@Param("bno") long bno, @Param("amount") int amount);	
	public long selectMax();
}
