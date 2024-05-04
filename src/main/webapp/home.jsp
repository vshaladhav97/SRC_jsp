<%@ page import="java.sql.*" %>
<%@ page import="oracle.jdbc.OracleTypes" %>
<%@ page import="oracle.jdbc.pool.OracleDataSource" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Student Records</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
            color: #333;
        }
        h1 {
            color: #444;
            text-align: center;
        }
        .container {
            margin: auto;
            max-width: 1100px;
            background: #fff;
            padding: 20px;
            box-shadow: 0px 0px 10px rgba(0,0,0,0.1);
        }
        form {
            margin-bottom: 20px;
            background-color: #fff;
            border-radius: 8px;
            width: 100%;
        }
        label {
            display: block;
            margin-bottom: 10px;
        }
        select, input[type="text"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border-radius: 4px;
            border: 1px solid #ddd;
            box-sizing: border-box;
        }
        input[type="submit"] {
         	width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border-radius: 4px;
            border: 1px solid #ddd;
            box-sizing: border-box;
            background: #009688;
    		color: #fff;
    		cursor: pointer;
        }
        input[type="submit"]:hover {
            background: #00796b;
        }
        select option {
    		padding: 10px;
    		background: #fff; /* Ensure a white background */
    		color: #333; /* Standard text color for readability */
		}
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }
        th {
           background-color: #009688;
           color: #fff;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .error {
            color: #d33;
        }
        select {
    		line-height: 1.5;
    		cursor: pointer;
		}

		/* Style focus state of select element */
		select:focus {
    		border-color: #aaa;
    		box-shadow: 0 0 3px #b0e0ee;
		}
    </style>
</head>
<body>
<div class="container">
<h1>Student Records</h1>
<%
    String action = request.getParameter("action");
    OracleDataSource ds = new OracleDataSource();
    ds.setURL("jdbc:oracle:thin:@castor.cc.binghamton.edu:1521:ACAD111");
    Connection conn = null;
    CallableStatement cstmt = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
        conn = ds.getConnection("vadhav", "Vshaladhav97");
%>
<form method="GET">
    <label for="action">Choose an action:</label>
    <select name="action" id="action" onchange="this.form.submit()">
        <option value="">Select...</option>
        <option value="show_students" <%= "show_students".equals(action) ? "selected" : "" %>>Display All Students</option>
        <option value="add_student" <%= "add_student".equals(action) ? "selected" : "" %>>Add New Student</option>
        <option value="edit_student" <%= "edit_student".equals(action) ? "selected" : "" %>>Edit Existing Student</option>
        <option value="delete_student" <%= "delete_student".equals(action) ? "selected" : "" %>>Delete a Student</option>
    </select>
</form>
<%
        if ("show_students".equals(action)) {
            cstmt = conn.prepareCall("{ call school_pkg.show_students(?) }");
            cstmt.registerOutParameter(1, OracleTypes.CURSOR);
            cstmt.execute();
            rs = (ResultSet) cstmt.getObject(1);
            if (!rs.isBeforeFirst()) {
                out.println("<p>No students found.</p>");
            } else {
                out.println("<table border='1'><tr><th>B#</th><th>First Name</th><th>Last Name</th><th>Level</th><th>GPA</th><th>Email</th></tr>");
                while (rs.next()) {
                    out.println("<tr><td>" + rs.getString("B#") + "</td><td>" + rs.getString("first_name") + "</td><td>" + rs.getString("last_name") + "</td><td>" + rs.getString("st_level") + "</td><td>" + rs.getDouble("gpa") + "</td><td>" + rs.getString("email") + "</td></tr>");
                }
                out.println("</table>");
            }
        } else if ("add_student".equals(action)) {
%>
<form method="POST" action="home.jsp?action=insert_student">
    <input type="text" name="B#" placeholder="B# (e.g., B00000001)" required><br>
    <input type="text" name="first_name" placeholder="First Name" required><br>
    <input type="text" name="last_name" placeholder="Last Name" required><br>
    <input type="text" name="st_level" placeholder="Level (e.g., freshman)" required><br>
    <input type="text" name="gpa" placeholder="GPA" required><br>
    <input type="text" name="email" placeholder="Email" required><br>
    <input type="submit" value="Add Student">
</form>
<%
        } else if (action != null && action.equals("insert_student")) {
            String bNo = request.getParameter("B#");
            String firstName = request.getParameter("first_name");
            String lastName = request.getParameter("last_name");
            String stLevel = request.getParameter("st_level");
            Double gpa = Double.valueOf(request.getParameter("gpa"));
            String email = request.getParameter("email");

            pstmt = conn.prepareStatement("INSERT INTO students (B#, first_name, last_name, st_level, gpa, email) VALUES (?, ?, ?, ?, ?, ?)");
            pstmt.setString(1, bNo);
            pstmt.setString(2, firstName);
            pstmt.setString(3, lastName);
            pstmt.setString(4, stLevel);
            pstmt.setDouble(5, gpa);
            pstmt.setString(6, email);
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                out.println("<p>Student added successfully.</p>");
            } else {
                out.println("<p>Error adding student.</p>");
            }
        } else if ("edit_student".equals(action)) {
            // Form to select the student to edit
%>
<form method="POST" action="home.jsp?action=select_for_edit">
    <input type="text" name="B#" placeholder="B# to Edit (e.g., B00000001)" required><br>
    <input type="submit" value="Edit Student">
</form>
<%
        } else if (action != null && action.equals("select_for_edit")) {
            String bNo = request.getParameter("B#");
            pstmt = conn.prepareStatement("SELECT * FROM students WHERE B# = ?");
            pstmt.setString(1, bNo);
            rs = pstmt.executeQuery();
            if (rs.next()) {
%>
<form method="POST" action="home.jsp?action=update_student">
    <input type="hidden" name="B#" value="<%= rs.getString("B#") %>"><br>
    First Name: <input type="text" name="first_name" value="<%= rs.getString("first_name") %>" required><br>
    Last Name: <input type="text" name="last_name" value="<%= rs.getString("last_name") %>" required><br>
    Level: <input type="text" name="st_level" value="<%= rs.getString("st_level") %>" required><br>
    GPA: <input type="text" name="gpa" value="<%= rs.getDouble("gpa") %>" required><br>
    Email: <input type="text" name="email" value="<%= rs.getString("email") %>" required><br>
    <input type="submit" value="Update Student">
</form>
<%
            } else {
                out.println("<p>Student not found with B# " + bNo + ".</p>");
            }
        } else if (action != null && action.equals("update_student")) {
            String bNo = request.getParameter("B#");
            String firstName = request.getParameter("first_name");
            String lastName = request.getParameter("last_name");
            String stLevel = request.getParameter("st_level");
            Double gpa = Double.valueOf(request.getParameter("gpa"));
            String email = request.getParameter("email");

            pstmt = conn.prepareStatement("UPDATE students SET first_name = ?, last_name = ?, st_level = ?, gpa = ?, email = ? WHERE B# = ?");
            pstmt.setString(1, firstName);
            pstmt.setString(2, lastName);
            pstmt.setString(3, stLevel);
            pstmt.setDouble(4, gpa);
            pstmt.setString(5, email);
            pstmt.setString(6, bNo);
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                out.println("<p>Student updated successfully.</p>");
            } else {
                out.println("<p>Error updating student.</p>");
            }
        }
    } catch (SQLException e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
        e.printStackTrace(new PrintWriter(out, true));
    } finally {
        try {
            if (rs != null) rs.close();
            if (cstmt != null) cstmt.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException ex) {
            out.println("<p>Error in closing resources: " + ex.getMessage() + "</p>");
        }
    }
%>
</div>
</body>
</html>
