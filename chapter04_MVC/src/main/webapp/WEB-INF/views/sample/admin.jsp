<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript">
	location.href='/board/list';
</script>
</head>
<body>

	<%-- 
	<h1>admin 페이지</h1>
	
	<p>principal : <sec:authentication property="principal"/></p>
	<p>MemberVO : <sec:authentication property="principal.member"/></p>
	<p>사용자 이름 : <sec:authentication property="principal.member.username"/></p>
	<p>사용자 아이디 : <sec:authentication property="principal.username"/></p>
	<p>사용자 권한 리스트 : <sec:authentication property="principal.member.authList"/></p>
	<!-- 
		<sec:authentication property="principal"/> == UserDetailService 에서 반환된 객체
		즉 CustomUserDetailService를 이용 했다면 loadUserByUserName()에서 반환된
		CustomUser 객체가 된다.
		즉 principal == CustomUser
	 -->
	
	<a href="/customLogout">Logout</a>
	 --%>
</body>
</html>