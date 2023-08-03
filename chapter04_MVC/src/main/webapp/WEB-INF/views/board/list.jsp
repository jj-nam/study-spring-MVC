<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../include/header.jsp" %>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Tables</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">게시글 목록</div>
				<button id="regBtn" class="btn btn-xs pull-right btn-primary">새 게시글 등록</button>
			<!-- /.panel-heading -->
			<div class="panel-body">
				<table class="table table-striped table-bordered table-hover">
					<thead>
						<tr>
							<th>#번호</th>
							<th>제목</th>
							<th>작성자</th>
							<th>작성일</th>
							<th>수정일</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="board" items="${list }">
							<tr>
								<td><c:out value="${board.bno}"></c:out></td>
								<td>
									<a class="move" href="${board.bno }">
									<c:out value="${board.title }"/><b>[ ${board.replycnt} ]</b>
									</a>
								</td>
								<td><c:out value="${board.writer}"></c:out></td>
								<td><fmt:formatDate value="${board.regdate}" pattern="yyyy-MM-dd"/></td>
								<td><fmt:formatDate value="${board.updatedate}" pattern="yyyy-MM-dd"/></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
				
				<!-- page -->
            <div class="pull-right">
               <ul class="pagination">
                  <c:if test="${pageMaker.prev }">
                     <li class="paginate_button previous">
                        <a href="${pageMaker.startPage-1 }">&lt;</a>
                     </li>
                  </c:if>
                  <c:forEach var="num" begin="${pageMaker.startPage }" end="${pageMaker.endPage }" step="1">
                     <li class="paginate_button ${pageMaker.cri.pageNum == num ? 'active' : '' }">   
                        <a href="${num }">${num }</a>
                     </li>
                  </c:forEach>
                  <c:if test="${pageMaker.next }">
                     <li class="paginate_button">
                        <a href="${pageMaker.endPage+1 }">&gt;</a>
                     </li>
                  </c:if>
               </ul>
            </div>
				
				<form action="/board/list" method="get" id="actionForm">
					<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum }">
					<input type="hidden" name="amount" value="${pageMaker.cri.amount }">
				</form>
				
			</div>
			<!-- /.panel-body -->
		</div>
		<!-- /.panel -->
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<script type="text/javascript">
	history.replaceState({}, null, location.pathname);
	$(function(){
		// 새 게시글 버튼 클릭 시 삽입 화면으로 이동
		$('#regBtn').click(function(){
			actionForm.attr('action', '/board/register');
			actionForm.submit();
			
			// location.href="/board/register";
		});
		/* document.getElementById("regBtn").onclick=function(){
			location.href = "/board/register";
		}; */
	});
	
	// 결과 창 출력을 위한 코드
	var result = '<c:out value="${result}"/>';
	
	// rttr 객체를 통해 받아온 값이 빈 값이 아닐 때 (데이터 변경) 알림 메소드 실행
	if(result != ''){
		checkResult(result);
	}
	
	// 뒤로 가기 할 때 문제가 될 수 있으므로
	// history 객체를 조작({정보를 담은 객체}, 뒤로가기 버튼 문자열 형태의 제목, 바꿀 url)
	function checkResult(result){
		if(result ==='' || history.state){ // 뒤로가기 방지
			return;
		}
		if(result === 'ok'){	// 삽입
			alert("게시글이 등록 되었습니다.")
			return;
		}
		if(result === 'success'){	// 수정 or 삭제
			alert("수정 / 삭제 되었습니다.")
			return;
		}
	}
	
	var actionForm = $("#actionForm");
	//-------------- 조회 화면 이동 이벤트 처리 ---------------
	$(".move").on('click',function(e){
		// <a> 클릭 시 페이지 이동이 이루어지지 않게 하기 위해
		e.preventDefault();
		
		// $(this)의 요소 중 href의 속성 값(value)
		actionForm.attr('action', '/board/get');	// 경로 변경
		var aa = '<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum }">';
		aa += '<input type="hidden" name="amount" value="${pageMaker.cri.amount }">';
		aa += "<input type='hidden' name='bno' value='" + $(this).attr('href') + "'/>";
		actionForm.html(aa);
		actionForm.submit();
	});
	
	//-------------- 페이징 버튼 이벤트 처리 ---------------
	$(".paginate_button a").on('click', function(e){
		e.preventDefault();

		actionForm.find("input[name='pageNum']").val($(this).attr("href"));
		actionForm.submit();
	});
	
</script>

<%@ include file="../include/footer.jsp" %>