<%@ page import="java.sql.*" %>
<%@ page import="oracle.jdbc.OracleCallableStatement" %>
<%@ page import="oracle.jdbc.pool.OracleDataSource" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Delete Student</title>
</head>
<body>
<h1>Delete Student</h1>
<form method="POST">
    Student B#: <input type="text" name="studentBNumber" required>
    <input type="submit" value="Delete Student">
</form>

<%
    String studentBNumber = request.getParameter("studentBNumber");
    if (studentBNumber != null && !studentBNumber.isEmpty()) {
        OracleDataSource ds = new OracleDataSource();
        ds.setURL("jdbc:oracle:thin:@castor.cc.binghamton.edu:1521:ACAD111"); // Adjust URL
        ds.setUser("vadhav"); //  database username
        ds.setPassword("Vshaladhav97"); //  database password
        Connection conn = null;
        CallableStatement cstmt = null;
        try {
            conn = ds.getConnection();
            conn.setAutoCommit(false); // Explicit transaction control

            cstmt = conn.prepareCall("{CALL delete_student(?)}");
            cstmt.setString(1, studentBNumber.trim());
            
            try {
                cstmt.execute();
                conn.commit();
                out.println("<p>Student with B# " + studentBNumber + " has been deleted successfully.</p>");
            } catch (SQLException e) {
                conn.rollback();
                out.println("<p>Error: " + e.getMessage() + "</p>");
            }
        } catch (Exception e) {
            out.println("<p>Database connection problem: " + e.getMessage() + "</p>");
        } finally {
            if (cstmt != null) try { cstmt.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
    }
%>
</body>
</html>
