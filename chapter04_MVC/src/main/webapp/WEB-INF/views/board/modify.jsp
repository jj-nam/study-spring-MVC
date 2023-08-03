<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../include/header.jsp" %>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">게시글 수정 / 삭제 화면</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">게시글 수정 / 삭제 화면</div>
			<div class="panel-body">
				<form action="/board/modify" method="post" role="form">
					<div class="form-group">
						<label>글 번호</label>
						<input class="form-control" name="bno" value="${vo.bno }" readonly="readonly" />
					</div>
					<div class="form-group">
						<label>글 제목</label>
						<input class="form-control" name="title" value="${vo.title }">
					</div>
					<div class="form-group">
						<label>글 내용</label>
						<textarea class="form-control" rows="3" name="content">${vo.content }</textarea>
					</div>
					<div class="form-group">
						<label>작성자</label>
						<input class="form-control" name="writer" value="${vo.writer }" readonly="readonly" />
					</div>
					
					<sec:authorize access="isAuthenticated()">	<!-- 권한 체크하는 영역 -->
					<c:if test="${pinfo.username eq vo.writer }">	<!-- 로그인 계정과 작성자가 같으면 -->
						<button type="submit" data-oper="modify" class="btn btn-primary">수정</button>
						<button type="submit" data-oper="remove" class="btn btn-danger">삭제</button>
					</c:if>
					</sec:authorize>
					
					<button type="submit" data-oper="list" class="btn btn-info">목록</button>
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
<div class = "row">
   <div class = "col-lg-12">
      <div class = "panel panel-default">
         <div class = "panel-heading">파일 첨부</div>
         <!-- /.panel-heading -->
         <div class = "panel-body">
            <div class = "panel-body">
               <div class = "form-group uploadDiv">
                  <input type = "file" name = 'uploadFile' multiple>
               </div>
               <div class = 'uploadResult'>
                  <ul></ul>
               </div>
            </div>
         </div>
      </div>
   </div>
</div>



<script type="text/javascript">
	
	$(function(){
		var formObj = $("form");
		
		$("button").on('click', function(e){
			e.preventDefault();
			
			var operation = $(this).data("oper");
			
			if(operation === 'remove'){
				formObj.attr('action','/board/remove');
			}else if(operation === 'list'){
				formObj.attr('action','/board/list');
				formObj.attr('method','get');
				
				var pageNumTag = $("input[name='pageNum']").clone();
				var amountTag = $("input[name='amount']").clone();
				
				formObj.empty();		
				
				formObj.append(pageNumTag);
				formObj.append(amountTag);
			}else if(operation === 'modify'){
				console.log("submit clicked");
				
				var str = "";
				
				$(".uploadResult ul li").each(function(i, obj){
					var jobj = $(obj);
					
					console.dir(jobj);
					
					str += "<input type='hidden' name='attachList[" + i + "].fileName' value='" + jobj.data("filename") + "'>";
					str += "<input type='hidden' name='attachList[" + i + "].uuid' value='" + jobj.data("uuid") + "'>";
					str += "<input type='hidden' name='attachList[" + i + "].uploadPath' value='" + jobj.data("uploadPath") + "'>";
				});
				formObj.append(str).submit();
			}
			formObj.submit();
		});
		
	})
</script>
<script type="text/javascript">
	$(function(){
		var bno = ${vo.bno};
		
		// get화면에 있던 첨부파일 modify로 불러오기
		$.getJSON("/board/getAttachList", {bno : bno}, function(arr){
			console.log(arr);
			var str = "";
			$(arr).each(function(i, attach){
			var fileCallPath = encodeURIComponent(attach.uploadPath + "/" + attach.uuid + "_" + attach.fileName);
				str += "<li data-path='" + attach.uploadPath + "'data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' ><div>";
				str += "<span><img src ='/resources/img/attach.png' style='width:15px'> " + attach.fileName + "</span>&nbsp;&nbsp;";
				str += "<button type='button' data-file='" + fileCallPath + "' data-type='file' ";
				str += "class = 'btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
				str += "</div>";
				str += "</li>";
			})
		
		$(".uploadResult ul").html(str);
		});	//end gson
		
		// 사용자 화면에서만 첨부파일이 delete 되어 보이게 끔 하는 기능
		$(".uploadResult").on("click", "button", function(e){
			
			console.log("delete file");
			
			if(confirm("Remove this file? ")){
				
				var targetLi = $(this).closest("li");
				targetLi.remove();
			}
		})
		
		$("input[type='file']").on('change', function(){
			$('.uploadResult ul').empty();
			var formData = new FormData();
			var inputFile = $("input[type='file']");
			var files = inputFile[0].files;
			
			for (var i = 0; i < files.length; i++) {
				if(!checkExtension(files[i].name, files[i].size)){
					return false;
				}
				
	            formData.append('uploadFile', files[i]);
	         }			
			
			$.ajax({
				type : 'post',
				url : '/uploadAjaxAction',
				data : formData,
				contentType : false,
				processData : false,
				dataType : 'json',
				success : function(result){
					console.log(result);
					$(".uploadDiv").html(cloneObj);
					showUploadFile(result);
				}
			})
		});
		
		var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");		// 정규식
		var maxSize = 5242880;		// 5MB
		
		var cloneObj = $(".uploadDiv input").clone();
		
		function checkExtension(fileName, fileSize){
			if(fileSize >= maxSize){
				alert("파일 사이즈 초과");
				return false;
			}
			
			if(regex.test(fileName)){
				alert("해당 종류의 파일은 업로드 할 수 없습니다.");
				return false;
			}
			
			return true;
		}
		
		
		var uploadResult = $(".uploadResult ul");
		function showUploadFile(uploadResultArr){
			var str = '';
			$(uploadResultArr).each(function(i, obj){
				
				var fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
				
				str += '<li data-path="'+obj.uploadPath+'" data-uuid="'+ obj.uuid +'" data-filename="' + obj.fileName + '">';
	            str += '<div>';
	            str += '<img src="/resources/img/attach.png" style="width:15px" />';
	            str += '<span>' + obj.fileName + '</span>';
	            str += '<button type="button" data-file="'+ fileCallPath +'" data-type="file" class="btn btn-warning btn-circle"><i class="fa fa-times"></i></button><br>';
	            str += '</div>';
	            str += '</li>';
			});
			uploadResult.html(str);
		}
		
	})	// end function
</script>

<%@include file="../include/footer.jsp" %>