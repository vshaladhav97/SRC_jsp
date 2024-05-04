<%@ page import="java.sql.*" %>
<%@ page import="oracle.jdbc.OracleTypes" %>
<%@ page import="oracle.jdbc.pool.OracleDataSource" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Course Prerequisites Lookup</title>
</head>
<body>
<h1>Course Prerequisites Lookup</h1>
<form method="POST">
    Enter Department Code: <input type="text" name="deptCode" required>
    Enter Course Number: <input type="text" name="courseNumber" required>
    <input type="submit" value="Search">
</form>

<%
    String deptCode = request.getParameter("deptCode");
    String courseNumber = request.getParameter("courseNumber");
    if (deptCode != null && courseNumber != null && !deptCode.trim().isEmpty() && !courseNumber.trim().isEmpty()) {
        OracleDataSource ds = new OracleDataSource();
        ds.setURL("jdbc:oracle:thin:@castor.cc.binghamton.edu:1521:ACAD111"); // Ensure URL is correctly configured
        try (Connection conn = ds.getConnection("vadhav", "Vshaladhav97");  // Use your username and password
             CallableStatement cstmt = conn.prepareCall("{call course_prereq_pkg.get_prerequisites(?, ?, ?)}")) {

            cstmt.setString(1, deptCode.trim());
            cstmt.setInt(2, Integer.parseInt(courseNumber.trim()));
            cstmt.registerOutParameter(3, OracleTypes.CURSOR); // Register the OUT parameter as CURSOR
            cstmt.execute();

            try (ResultSet rs = (ResultSet) cstmt.getObject(3)) { // Retrieve the cursor as a ResultSet
                if (rs != null && rs.isBeforeFirst()) {
                    out.println("<table border='1'><tr><th>Course Identifier</th><th>Direct Prerequisite</th><th>Indirect Prerequisite</th></tr>");
                    while (rs.next()) {
                        String directPreq = rs.getString("direct_prerequisite") != null ? rs.getString("direct_prerequisite") : "None";
                        String indirectPreq = rs.getString("indirect_prerequisite") != null ? rs.getString("indirect_prerequisite") : "None";
                        out.println("<tr><td>" + rs.getString("course_identifier") + "</td><td>" + directPreq + "</td><td>" + indirectPreq + "</td></tr>");
                    }
                    out.println("</table>");
                } else {
                    out.println("<p>No prerequisites found or invalid course details.</p>");
                }
            }
        } catch (SQLException e) {
            out.println("Error: " + e.getMessage());
            e.printStackTrace();  // For debugging, remove or use proper logging in production.
        }
    }
%>
</body>
</html>
