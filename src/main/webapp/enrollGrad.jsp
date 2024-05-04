<%@ page import="java.sql.*" %>
<%@ page import="oracle.jdbc.OracleCallableStatement" %>
<%@ page import="oracle.jdbc.pool.OracleDataSource" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Graduate Enrollment Form</title>
</head>
<body>
<h1>Graduate Student Class Enrollment</h1>
<form method="POST">
    Student B#: <input type="text" name="studentId" required>
    Class ID: <input type="text" name="classId" required>
    <input type="submit" value="Enroll">
</form>

<%
    String studentId = request.getParameter("studentId");
    String classId = request.getParameter("classId");
    if (studentId != null && classId != null && !studentId.isEmpty() && !classId.isEmpty()) {
        OracleDataSource ds = new OracleDataSource();
        ds.setURL("jdbc:oracle:thin:@castor.cc.binghamton.edu:1521:ACAD111"); // Ensure this URL is correct
        ds.setUser("vadhav"); // Your database username
        ds.setPassword("Vshaladhav97"); // Your database password
        Connection conn = null;
        CallableStatement cstmt = null;
        try {
            conn = ds.getConnection();
            conn.setAutoCommit(false); // Managing transaction explicitly

            // Enable DBMS output to capture procedure prints
            CallableStatement stmtOutput = conn.prepareCall("{call dbms_output.enable(?) }");
            stmtOutput.setInt(1, 10000);
            stmtOutput.execute();
            stmtOutput.close();

            cstmt = conn.prepareCall("{CALL enroll_grad_proc(?, ?)}");
            cstmt.setString(1, studentId.trim());
            cstmt.setString(2, classId.trim());
            cstmt.execute();
            conn.commit();  // Commit the transaction explicitly

            // Retrieve DBMS output
            CallableStatement getOutputStmt = conn.prepareCall("{call dbms_output.get_line(?, ?)}");
            getOutputStmt.registerOutParameter(1, Types.VARCHAR);
            getOutputStmt.registerOutParameter(2, Types.INTEGER);
            String line;
            int status = 0;
            while (status == 0) {
                getOutputStmt.execute();
                line = getOutputStmt.getString(1);
                status = getOutputStmt.getInt(2);
                if (line != null) {
                    out.println("<p>" + line + "</p>");
                }
            }
            getOutputStmt.close();

            out.println("<p>Enrollment Attempted. Please check the database for results.</p>");
        } catch (SQLException e) {
            out.println("<p>Error during procedure call: " + e.getMessage() + "</p>");
            try {
                if (conn != null) conn.rollback(); // Rollback in case of any exception
            } catch (SQLException se) {
                out.println("<p>Failed to rollback transaction: " + se.getMessage() + "</p>");
            }
            e.printStackTrace();  // Print the stack trace for debugging
        } finally {
            if (cstmt != null) try { cstmt.close(); } catch (Exception e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }
%>
</body>
</html>
