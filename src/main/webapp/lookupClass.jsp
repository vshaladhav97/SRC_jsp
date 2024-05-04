<%@ page import="java.sql.*" %>
<%@ page import="oracle.jdbc.OracleTypes" %>
<%@ page import="oracle.jdbc.pool.OracleDataSource" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Class Enrollment Lookup</title>
</head>
<body>
<h1>Class Enrollment Lookup</h1>
<form method="POST">
    Enter Class ID: <input type="text" name="classid" required>
    <input type="submit" value="Search">
</form>

<%
    String classid = request.getParameter("classid");
    if (classid != null && !classid.trim().isEmpty()) {
        OracleDataSource ds = new OracleDataSource();
        ds.setURL("jdbc:oracle:thin:@castor.cc.binghamton.edu:1521:ACAD111");
        try (Connection conn = ds.getConnection("vadhav", "Vshaladhav97");
             CallableStatement cstmt = conn.prepareCall("{ CALL class_info.list_students(?, ?) }")) {

            cstmt.setString(1, classid);
            cstmt.registerOutParameter(2, OracleTypes.CURSOR);
            cstmt.execute();

            ResultSet rs = (ResultSet) cstmt.getObject(2);
            if (rs.isBeforeFirst()) {
                out.println("<table border='1'><tr><th>B#</th><th>First Name</th><th>Last Name</th></tr>");
                while (rs.next()) {
                    out.println("<tr><td>" + rs.getString("B#") + "</td><td>" + rs.getString("first_name") + "</td><td>" + rs.getString("last_name") + "</td></tr>");
                }
                out.println("</table>");
            } else {
                out.println("<p>No students found for this class or invalid class ID.</p>");
            }
            rs.close();
        } catch (SQLException e) {
            out.println("Error: " + e.getMessage());
        }
    }
%>
</body>
</html>
