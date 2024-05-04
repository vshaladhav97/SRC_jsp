<%@ page import="java.sql.*" %>
<%@ page import="oracle.jdbc.OracleCallableStatement" %>
<%@ page import="oracle.jdbc.pool.OracleDataSource" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Drop Graduate Student from Class</title>
</head>
<body>
<h1>Drop Graduate Student from Class</h1>
<form method="POST">
    Student B#: <input type="text" name="studentId" required>
    Class ID: <input type="text" name="classId" required>
    <input type="submit" value="Drop Student">
</form>

<%
    String studentId = request.getParameter("studentId");
    String classId = request.getParameter("classId");
    if (studentId != null && classId != null && !studentId.isEmpty() && !classId.isEmpty()) {
        OracleDataSource ds = new OracleDataSource();
        ds.setURL("jdbc:oracle:thin:@castor.cc.binghamton.edu:1521:ACAD111"); 
        ds.setUser("vadhav"); //  Oracle DB username
        ds.setPassword("Vshaladhav97"); //  Oracle DB password
        Connection conn = null;
        CallableStatement cstmt = null;
        try {
            conn = ds.getConnection();
            cstmt = conn.prepareCall("{CALL Drop_Grad(?, ?)}");
            cstmt.setString(1, studentId.trim());
            cstmt.setString(2, classId.trim());

            cstmt.execute();
            out.println("<p>Drop attempt for student " + studentId + " from class " + classId + " has been executed. Check logs for details.</p>");
        } catch (SQLException e) {
            out.println("<p>Error during procedure call: " + e.getMessage() + "</p>");
        } finally {
            if (cstmt != null) try { cstmt.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
    }
%>
</body>
</html>
