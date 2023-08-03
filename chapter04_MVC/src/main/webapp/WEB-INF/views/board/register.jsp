<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../include/header.jsp" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">게시글 등록</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">게시글 등록</div>
			<!-- /.panel-heading -->
			<div class="panel-body">
				<form action="/board/register" method="post" role="form">
					<div class="form-group">
						<label>제목</label>
						<input class="form-control" name="title">
					</div>
					<div class="form-group">
						<label>내용</label>
						<textarea class="form-control" rows="3" name="content"></textarea>
					</div>
					<div class="form-group">
						<label>작성자</label>
						<input class="form-control" name="writer" value='<sec:authentication property="principal.username"/>' readonly="readonly">
					</div>
					<button type="submit" data-oper="register" class="btn btn-primary">등록</button>
 					<button type="reset" data-oper="reset" class="btn btn-warning">취소</button>
 					<button type="submit" data-oper="list" class="btn btn-info">목록으로</button>
 					<input type="hidden" name="pageNum" value="${cri.pageNum }">
					<input type="hidden" name="amount" value="${cri.amount }">
					<input type="hidden" name="${_csrf.parameterName}" value="${_csfr.token }">
				</form>
			</div>
			<!-- /.panel-body -->
		</div>
		<!-- /.panel -->
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->
<!-- 첨부파일 -->
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
			
			if(operation === 'register'){
				formObj.attr('action','/board/register');
				
				var str = '';
				$(".uploadResult ul li").each(function(i, obj){
					var jobj = $(obj);
					str += '<input type="hidden" name="attachList[' + i + '].fileName" value="' + jobj.data('filename') + '"/>';				
					str += '<input type="hidden" name="attachList[' + i + '].uuid" value="' + jobj.data('uuid') + '"/>';			
					str += '<input type="hidden" name="attachList[' + i + '].uploadPath" value="' + jobj.data('path') + '"/>';					
				});
				
				formObj.append(str);
				
			}else if(operation === 'list'){
				formObj.attr('action','/board/list');
				formObj.attr('method','get');
				
				// hidden 처리한 pageNum과 amount를 따로 저장해둔다
				var pageNumTag = $("input[name='pageNum']").clone();
				var amountTag = $("input[name='amount']").clone();
				
				formObj.empty();		// 해당 요소 내부 초기화
				
				formObj.append(pageNumTag);
				formObj.append(amountTag);
			}else if(operation === 'reset'){
				formObj[0].reset();	
				return;
			}
			
			formObj.submit();
		});
		
	})
</script>
<script type="text/javascript"> <!-- 파일 업로드 스크립트 -->
	$(function(){
		// input=file 변경시 fileInputChange() 함수 실행
		$("input[type='file']").on('change', function(){
			fileInputChange();
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
		
		function fileInputChange(){
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
		// 첨부 파일 삭제 클릭 이벤트
		uploadResult.on('click','button', function(){
			var targetFile = $(this).data('file');
			var targetLi = $(this).closest("li");
			
			$.ajax({
				type : 'post',
				url : '/deleteFile',
				data : {fileName : targetFile},
				dataType : 'text',
				success : function(result){
					targetLi.remove();
				}
			})
		});
		
	});
		
</script>
<%@include file="../include/footer.jsp" %>