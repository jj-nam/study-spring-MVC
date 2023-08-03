package org.joonzis.service;

import java.util.List;

import org.joonzis.domain.BoardAttachVO;
import org.joonzis.domain.BoardVO;
import org.joonzis.domain.Criteria;
import org.joonzis.mapper.BoardAttachMapper;
import org.joonzis.mapper.BoardMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.log4j.Log4j;

@Log4j
@Service	//service 코드는 무조건 추가 
public class BoardServiceImpl implements BoardService{
	
	@Autowired
	private BoardMapper mapper;
	
	@Autowired
	private BoardAttachMapper aMapper;
	
	@Override
	public List<BoardVO> getList(Criteria cri) {
		log.info("getList...");
		return mapper.getListWithPaging(cri);
	}
	
	@Transactional
	@Override
	public void register(BoardVO vo) {
		log.info("getResister...");
		
		mapper.insert(vo);
		
		long bno = mapper.selectMax();
		
		if(vo.getAttachList() != null && vo.getAttachList().size() > 0) {
			List<BoardAttachVO> list = vo.getAttachList();
			for (BoardAttachVO avo : list) { 
				avo.setBno(bno);
				aMapper.insert(avo);
			}
		}
	}
		
	@Override
	public BoardVO get(long bno) {
		log.info("getGet...");
		return mapper.read(bno);
	}
	
	@Transactional
	@Override
	public boolean remove(long bno) {
		log.info("getRemove...");
		aMapper.deleteAll(bno);
		
		return mapper.delete(bno) == 1;
	}
	
	@Transactional
	@Override
	public boolean modify(BoardVO vo) {
		log.info("getModify..." + vo);
		
		aMapper.deleteAll(vo.getBno());
		
		boolean modifyResult = mapper.update(vo) == 1;
		System.out.println(vo.getAttachList());
		if(modifyResult && vo.getAttachList() != null && vo.getAttachList().size() > 0){
				vo.getAttachList().forEach(attach -> {
					attach.setBno(vo.getBno());
					aMapper.insert(attach);
				});
			}
		return modifyResult;
	}
	@Override
	public int getTotal() {
		log.info("total...");
		return mapper.getTotalcount();
	}
	@Override
	public List<BoardAttachVO> getAttachList(long bno) {
		log.info("getAttachList..." + bno);
		return aMapper.findByBno(bno);
	}
	@Override
	public BoardAttachVO getBoardVO(long bno) {
		log.info("getAttachVO..." + bno);
		return aMapper.getBoardVO(bno);
	}

}