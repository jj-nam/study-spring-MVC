<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../include/header.jsp" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">게시글 화면</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">게시글 화면</div>
			<div class="panel-body">
				<div class="form-group">
					<label>글 번호</label>
					<input class="form-control" name="bno" value="${vo.bno }" readonly="readonly" />
				</div>
				<div class="form-group">
					<label>글 제목</label>
				<input class="form-control" name="title" value="${vo.title }" readonly="readonly">
				</div>
				<div class="form-group">
					<label>글 내용</label>
					<textarea class="form-control" rows="3" name="content" readonly="readonly">${vo.content }</textarea>
				</div>
				<div class="form-group">
					<label>작성자</label>
					<input class="form-control" name="writer" value="${vo.writer }" readonly="readonly" />
				</div>
				<sec:authentication property="principal" var="pinfo"/>
				<sec:authorize access="isAuthenticated()">	<!-- 권한 체크하는 영역 -->
					<c:if test="${pinfo.username eq vo.writer }">	<!-- 로그인 계정과 작성자가 같으면 -->
						<button data-oper="modify" class="btn btn-primary">수정</button>
					</c:if>
				</sec:authorize>
				<button data-oper="list" class="btn btn-info">목록</button>
				
				<form action="/board/modify" method="get" id="operForm">
					<input type="hidden" name="bno" id="bno" value="${vo.bno }">
					<input type="hidden" name="pageNum" value="${cri.pageNum }">
					<input type="hidden" name="amount" value="${cri.amount }">
				</form>
			</div>
			<!-- /.panel-body -->
		</div>
		<!-- /.panel -->
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class = 'row'>
   <div class = "col-lg-12">
      <!-- /.panel -->
      <div class = "panel panel-default">
         <div class= "panel-heading">
            <i class = "fa fa-comments fa-fw"></i> 댓글 <b>( ${vo.replycnt} )</b>
            <sec:authorize access="isAuthenticated()">	<!-- 권한 체크하는 영역 -->
	            <button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">댓글 달기</button>
			</sec:authorize>
         </div>
         <!-- /.panel-heading -->
         <div class = "panel-body">
            <ul class = "chat">
               <!-- start reply -->
               
               <!-- 새로고침 했을 때 이질감이 느껴지면 지워도 된다 
               <li class = "left clearfix" data-rno = '12'>
                  <div>
                     <div class = "header">
                        <strong class = "primary-font">user00</strong>
                        <small class = "pull-right text-muted">2018-01-01 13:13</small>                        
                     </div>
                     <p>Good job!</p>
                  </div>
               </li> 
               -->
               
               <!-- end reply -->
            </ul>
            <!-- ./ end ul -->
         </div>
         <!-- /.panel .chat-panel -->
      </div>
   </div>
   <!-- ./end row -->
</div>

<!-- Modal -->
<div class="modal fade" id = "MyModal" tabindex = "-1" role = "dialog"
   aria-labelledby = "myModalLabel" aria-hidden = "true">
   <div class = "modal-dialog">
      <div class = "modal-content">
         <div class = "modal-header">
            <button type = "button" class = "close" data-dismiss = "modal"
               ari-hidden = "true">&times;</button>
            <h4 class = "modal-title" id = "myModalLabel">새 게시글 등록</h4>
         </div>
         <div class = "modal-body">
            <div class = "form-group">
               <label>댓글</label>
               <input class = "form-control" name = 'reply' value = 'New Reply!!!!'>
            </div>
            <div class = "form-group">
               <label>작성자</label>
               <input class = "form-control" name = 'replyer' value = 'replyer'>
            </div>
            <div class = "form-group">
               <label>등록 날짜</label>
               <input class = "form-control" name = 'replyDate' value = '' >
            </div>
         </div>
         <div class = "modal-footer">
            <button id = 'modalModBtn' type = "button" class = "btn btn-warning">수정</button>
            <button id = 'modalRemoveBtn' type = "button" class = "btn btn-danger">삭제</button>
            <button id = 'modalRegisterBtn' type = "button" class = "btn btn-primary">등록</button>
            <button id = 'modalCloseBtn' type = "button" class = "btn btn-default">취소</button>
         </div>
      </div>
   </div>
</div>
<!-- 첨부파일 -->
<div class = "row">
   <div class = "col-lg-12">
      <div class = "panel panel-default">
         <div class = "panel-heading">파일 첨부</div>
         <!-- /.panel-heading -->
         <div class = "panel-body">
            <div class = "panel-body">
               <div class = 'uploadResult'>
                  <ul></ul>
               </div>
            </div>
         </div>
      </div>
   </div>
</div>
<script type="text/javascript" src="/resources/js/reply.js"></script>
<script type="text/javascript"> <!-- 첨부 파일 스크립트 -->
	$(function(){
		// ajax로 파일 목록 받아오기
		// 받아 온 리스트 반복하여 동적 태그 생성 후 uploadResult ul 내부에 저장
		
			$.ajax({
				type : 'get',
				url : '/board/getAttachList',
				data : {bno: bnoValue},
				contentType : 'application/json; chatset=utf-8',
				success : function(uploadResultArr){
					
					var str = '';
					
					$(uploadResultArr).each(function(i, obj){
						
						var fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
						
						str += '<li>';
						'<sec:authorize access="isAuthenticated()">';
							str += '<a href="/download?fileName=' + fileCallPath + '">';
						'</sec:authorize>'
						str += '<img src="/resources/img/attach.png" style="width:15px"> ' + obj.fileName;
						str += '</a>';
						str += '</li>';
					});
					$(".uploadResult ul").html(str);
				},
			});
	})
</script>
<script type="text/javascript">	<!-- 화면 이동 스크립트 -->
	$(function(){
		var operForm = $("#operForm");
		
		// 수정 화면 이동 버튼 클릭 시 bno 값을 같이 전달 --> 기존 내부 input 태그 그대로 전달
		$("button[data-oper='modify']").on('click',function(){
			operForm.submit();
		});
		// 목록화면 이동 버튼 클릭 시 bno 값 없이 이동 --> 기존 내부 input 태그 삭제 후 이동 
		$("button[data-oper='list']").on('click',function(){
			operForm.find("#bno").remove();
			operForm.find("#pageNum").remove();
			operForm.attr('action', '/board/list');
			operForm.submit();
		});
	})
	
</script>
<script type="text/javascript">	<!-- 댓글 & 모달 스크립트 -->
	console.log("============");
	console.log("JS TEST");
	
	var bnoValue = '${vo.bno}';
	
	$(function(){
		var replyUL = $(".chat");	// 댓글 리스트 UL
		showList();					// 댓글 리스트 바인딩 함수 호출
		
		// 댓글 리스트 바인딩 함수
		function showList(){
			// restController로 부터 댓글 리스트를 받아와
			// 위 댓글 ul 태그 내에 댓글 리스트 바인딩
			replyService.getList(
				{bno:bnoValue, page:1}, 
				function(result){
					var str = '';
					
					if(result == null || result.length == 0){
						// 댓글 리스트가 없으면
						replyUL.html('');
					}else{
						// 댓글 리스트가 있으면
						for(var i=0; i<result.length; i++){
							
							str += '<li class = "left clearfix" data-rno = "' + result[i].rno + '">';
							str += '<div>';
							str += '<div class = "header">';
							str += '<strong class = "primary-font">' + result[i].replyer + '</strong>';
							str += '<small class = "pull-right text-muted">' + displayTime(result[i].replyDate) + '</small>' ;                     
							str += '</div>';
							str += '<p>' + result[i].reply + '</p>';
							str += '</div>';
							str += '</li>';
						}
						replyUL.html(str);
					}
				}
			);
		}	// end showList()
		
		var pinfo;
		'<sec:authorize access="isAuthenticated()">';		
			pinfo = '<sec:authentication property="principal.username"/>';
		'</sec:authorize>';		
		
		// 모달 창 관련 스크립트
		var modal = $(".modal");
		var modalInputReply = modal.find("input[name='reply']");			// 댓글 내용 input
		var modalInputReplyer = modal.find("input[name='replyer']");		// 댓글 작성자 input
		var modalInputReplyDate = modal.find("input[name='replyDate']");	// 댓글 날짜 input
		
		var modalModBtn = $("#modalModBtn");			// 댓글 수정 버튼
		var modalRemoveBtn = $("#modalRemoveBtn");		// 댓글 삭제 버튼
		var modalRegisterBtn = $("#modalRegisterBtn");	// 댓글 등록 버튼
		var modalCloseBtn = $("#modalCloseBtn");		// 댓글 취소 버튼
		
		// 댓글 달기 버튼 클릭 이벤트		
		$("#addReplyBtn").on('click', function(){
			modal.find("input").val('');				// 입력 창 비우기
			modalInputReplyDate.closest('div').hide();	// 등록 날짜 입력 창 숨기기
			modalModBtn.hide();		// 댓글 수정 버튼 숨기기
			modalRemoveBtn.hide();	// 댓글 제거 버튼 숨기기
			modalInputReplyer.val(pinfo).attr("readonly",true);
			modalRegisterBtn.show();	// 등록 버튼 보이기
			// 모달 창 보이기
			modal.modal('show');		// 앞 modal = var modal,  뒤 modal= 함수
		});	
		
			// 댓글 입력 버튼 클릭 이벤트
			modalRegisterBtn.on('click', function(){
				replyService.add(
						{reply: modalInputReply.val(), 
							replyer:modalInputReplyer.val(), 
							bno:bnoValue},
						function(result){
								showList();
								modal.modal('hide');	// 모달 창 숨기기
						}
				);
			});
			// 댓글 취소 버튼 클릭 이벤트 
			modalCloseBtn.on('click', function(){
				modal.find("input").val('');
				modal.modal('hide');
			})
			
			// chat 클래스(UL) 내의 li 객체 클릭 이벤트
			// 클릭이 되면 눌려진 객체 (this)가 가지고 있는 rno를 통해서 함수 호출
			// 데이터 가져온 뒤 모달 창에 내용 출력
			// * click() , on('click') 함수 차이
			// click() - 동적 데이터 이벤트 바인딩 불가능
			// on('click') - 동적 데이터 이벤트 바인딩 가능
			var rno;
			$('.chat').on('click', 'li', function(){
				rno = $(this).data('rno');
				
				replyService.get(
						rno,
						function(result){
							modalInputReply.val(result.reply)								// 내용 (수정 가능)
							modalInputReplyer.val(result.replyer).attr("readonly",true);	// 작성자 (수정 불가능) - readonly
							modalInputReplyDate.val(displayTime(result.replyDate)).attr("readonly",true);// 작성일 (수정 불가능) - readonly, 날짜 포맷 변경
							modalInputReplyDate.closest('div').show();	// 등록 날짜 input 보이기
							if(pinfo == result.replyer){
								modalModBtn.show();		// 댓글 수정 버튼 보이기
								modalRemoveBtn.show();	// 댓글 제거 버튼 보이기
							}else{
								modalModBtn.hide();		// 댓글 수정 버튼 보이기
								modalRemoveBtn.hide();	// 댓글 제거 버튼 보이기
							}
							
							modalRegisterBtn.hide();
							modal.modal('show');		// 모달 창 보이기				
						}
				);
			})
			// 삭제 버튼
			modalRemoveBtn.on('click', function(){
				replyService.remove(
						rno,
						function(result){
							showList();
							modal.modal('hide');
						}
					)
			})
			
			// 수정 버튼
			modalModBtn.on('click', function(){
				replyService.modify(
				{rno : rno, reply: modalInputReply.val(), replyer: modalInputReplyer.val()},
					function(result){
						showList();
						modal.modal('hide');
					}
				) 
				
			});
	})
	
	
	/* 
	var date = new Date();
	replyService.modify(
		{rno : 5, reply:"JS 모디", replyer:"모디모디", updatedate:date},
		function(result){
			if(result==='success'){
				alert("수정 완료")
			}else{
				alert("수정 실패")
			}
		}
	)
	
	
	replyService.remove(
		5,
		function(result){
			if(result==='success'){
				alert("삭제 완료")
			}else{
				alert("삭제 실패")
			}
		}
	)
	
	
	replyService.get(
		4,
		function(result){
			console.log(result);
		}
	)
	
	var bnoValue = '${vo.bno}';
	
	replyService.getList(
			{bno:bnoValue, page:1}, 
			function(result){
				
			}
	);
	
	replyService.add(
		{reply:"JS TEST", replyer:"tester", bno:bnoValue},
		function(result){
			alert("result : " + result);
		}
	);
	 */
	 
	 
</script>

<%@include file="../include/footer.jsp" %>