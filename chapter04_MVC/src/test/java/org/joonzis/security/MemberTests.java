package org.joonzis.security;

import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.sql.DataSource;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@WebAppConfiguration
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"file:src/main/webapp/WEB-INF/spring/root-context.xml",
						"file:src/main/webapp/WEB-INF/spring/security-context.xml"})
public class MemberTests {
	
	@Setter(onMethod_ = @Autowired)
	private DataSource ds;
	
	@Setter(onMethod_ = @Autowired)
	private PasswordEncoder pwencoder;
	
	/*
	@Test
	public void testInsertMember() {
		String sql = "insert into tbl_member(userid, userpw, username) values(?,?,?)";
		
		for(int i=0; i<100; i++) {
			Connection conn = null;
			PreparedStatement ps = null;
			
			try {
				conn = ds.getConnection();
				ps = conn.prepareStatement(sql);
				
				// 비밀번호 인코딩
				ps.setString(2, pwencoder.encode("pw" + i));
				if(i<80) {
					ps.setString(1, "user" + i);
					ps.setString(3, "일반사용자" + i);
				}else if(i<90){
					ps.setString(1, "manager" + i);
					ps.setString(3, "운영자" + i);
				}else {
					ps.setString(1, "admin" + i);
					ps.setString(3, "관리자" + i);
				}
				ps.executeUpdate();
			} catch (Exception e) {
				e.printStackTrace();
			}finally {
				try {
					if(ps != null) {ps.close();}
					if(conn != null) {conn.close();}
				} catch (Exception e2) {
					e2.printStackTrace();
				}
			}
		}	// end for loop
		
	}
	*/
	
	@Test
	public void testInsertMemberAuth() {
		
		// 일반 사용자 - ROLE_USER
		// 운영자 - ROLE_MEMBER
		// 관리자 - ROLE_ADMIN
		
		String sql = "insert into tbl_member_auth(userid, auth) values(?,?)";
		
		for(int i=0; i<100; i++) {
			Connection conn = null;
			PreparedStatement ps = null;
			
			try {
				conn = ds.getConnection();
				ps = conn.prepareStatement(sql);
				
				if(i<80) {
					ps.setString(1, "user" + i);
					ps.setString(2, "ROLE_USER");
				}else if(i<90){
					ps.setString(1, "manager" + i);
					ps.setString(2, "ROLE_MEMBER");
				}else {
					ps.setString(1, "admin" + i);
					ps.setString(2, "ROLE_ADMIN");
				}
				ps.executeUpdate();
			} catch (Exception e) {
				e.printStackTrace();
			}finally {
				try {
					if(ps != null) {ps.close();}
					if(conn != null) {conn.close();}
				} catch (Exception e2) {
					e2.printStackTrace();
				}
			}
		}
	}
	
}
