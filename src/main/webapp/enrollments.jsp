<%@ page import="java.sql.*" %>
<%@ page import="oracle.jdbc.pool.OracleDataSource" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Manage Enrollments</title>
        <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f7f7f7;
            margin: 0;
            padding: 20px;
        }
        .container {    
            margin-top: 20px;
            background: #fff;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }
        h1 {
            text-align: center;
            color: #333;
        }
        form {
            margin-top: 20px;
            display: flex;
            flex-direction: column;
            align-items: flex-start;
        }
        form label {
            margin: 10px 0 5px;
        }
        form input[type="text"],
        form select {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        form input[type="submit"] {
            cursor: pointer;
            padding: 10px 15px;
            background-color: #5cb85c;
            border: none;
            border-radius: 4px;
            color: white;
            transition: background-color 0.3s ease;
        }
        form input[type="submit"]:hover {
            background-color: #4cae4c;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table, th, td {
            border: 1px solid #ddd;
            text-align: left;
            padding: 8px;
        }
        th {
             background-color: #009688;
            color: #fff;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .error {
            color: #d9534f;
        }
        .success {
            color: #5cb85c;
        }
                #site-header {
        background: #004333;
    height: 4rem;
    color: #fff;
    display: -webkit-box;
    display: -ms-flexbox;
    display: flex;
    position: fixed;
    width: 100%;
    top: 0;
    left: 0;
    margin-bottom: 4rem;
    z-index: 9999;
}

.title-area {
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
    padding: 10px;
}
#site-title {
	max-width: 24rem;
    width: 100%;
}

#site-title a {
	height: 2.8rem;
    margin: 0.5rem 0.3rem;
    display: block;
    background-image: url(//www.binghamton.edu/assets/img/logo/binghamton-university.png);
    background-color: transparent;
    background-size: contain;
    background-repeat: no-repeat;
    background-position: left center;
    border: 0;
    font: 0/0 a;
    text-shadow: none;
    color: transparent;
}

.site-link {
    text-decoration: none;
    color: #333; /* Set your desired link color */
    font-size: 1.2rem; /* Set your desired font size */
    font-weight: bold; /* Set font weight for emphasis */
}

.section-header {
    font-size: 1.1rem; /* Set your desired font size */
    color: #666; /* Set your desired color */
}

.header-navigation {
    display: flex;
    align-items: center;
}

.nav-btn {
    margin-left: 15px; /* Adjust spacing between buttons */
    cursor: pointer;
}

.nav-btn div {
    display: flex;
    align-items: center;
    color: #666; /* Set your desired color */
}

.nav-btn span {
    margin-left: 5px; /* Adjust spacing between icon and text */
}
    </style>
</head>
<body>
<header id="site-header" class="nav-bar minimized">
		<div class="title-area">
			<div id="site-title">
				<a href="http://localhost:8082/DB_Project/">Binghamton University: The State University of New York</a>
			</div>	
		</div>
</header>
<div class="container">
<h1>Manage Enrollments</h1>
<%
    String action = request.getParameter("action");
    OracleDataSource ds = new OracleDataSource();
    ds.setURL("jdbc:oracle:thin:@castor.cc.binghamton.edu:1521:ACAD111");
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
        conn = ds.getConnection("vadhav", "Vshaladhav97");
%>
<form method="GET" action="enrollments.jsp">
    <label for="action">Choose an action:</label>
    <select name="action" id="action" onchange="this.form.submit()">
        <option value="">Select...</option>
        <option value="view_enrollments" <%= "view_enrollments".equals(action) ? "selected" : "" %>>View All Enrollments</option>
        <option value="add_enrollment" <%= "add_enrollment".equals(action) ? "selected" : "" %>>Enroll a Student</option>
        <option value="drop_enrollment" <%= "drop_enrollment".equals(action) ? "selected" : "" %>>Drop a Student</option>
    </select>
</form>

<%
        if ("view_enrollments".equals(action)) {
            pstmt = conn.prepareStatement("SELECT e.g_B#, e.classid, s.first_name, s.last_name, c.title FROM g_enrollments e JOIN students s ON e.g_B# = s.B# JOIN classes cl ON e.classid = cl.classid JOIN courses c ON cl.dept_code = c.dept_code AND cl.course# = c.course#");
            rs = pstmt.executeQuery();
            if (!rs.isBeforeFirst()) {
                out.println("<p>No enrollments found.</p>");
            } else {
                out.println("<table border='1'><tr><th>Student ID</th><th>Class ID</th><th>Student Name</th><th>Course Title</th></tr>");
                while (rs.next()) {
                    out.println("<tr><td>" + rs.getString("g_B#") + "</td><td>" + rs.getString("classid") + "</td><td>" + rs.getString("first_name") + " " + rs.getString("last_name") + "</td><td>" + rs.getString("title") + "</td></tr>");
                }
                out.println("</table>");
            }
        } else if ("add_enrollment".equals(action) || "drop_enrollment".equals(action)) {
%>
<form method="POST" action="enrollments.jsp?action=<%= action.equals("add_enrollment") ? "insert" : "delete" %>">
    Student ID: <input type="text" name="g_B#" required><br>
    Class ID: <input type="text" name="classid" required><br>
    <input type="submit" value="<%= action.equals("add_enrollment") ? "Enroll Student" : "Drop Student" %>">
</form>
<%
        } else if ("insert".equals(action)) {
            String studentID = request.getParameter("g_B#");
            String classID = request.getParameter("classid");
            pstmt = conn.prepareStatement("INSERT INTO g_enrollments (g_B#, classid) VALUES (?, ?)");
            pstmt.setString(1, studentID);
            pstmt.setString(2, classID);
            try {
                pstmt.executeUpdate();
                out.println("<p>Enrollment added successfully!</p>");
            } catch (SQLException e) {
                out.println("<p>Error enrolling student: " + e.getMessage() + "</p>");
            }
        } else if ("delete".equals(action)) {
            String studentID = request.getParameter("g_B#");
            String classID = request.getParameter("classid");
            pstmt = conn.prepareStatement("DELETE FROM g_enrollments WHERE g_B# = ? AND classid = ?");
            pstmt.setString(1, studentID);
            pstmt.setString(2, classID);
            int count = pstmt.executeUpdate();
            if (count > 0) {
                out.println("<p>Enrollment dropped successfully!</p>");
            } else {
                out.println("<p>Error dropping enrollment: Enrollment not found or could not be deleted.</p>");
            }
        }
    } catch (SQLException e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
        e.printStackTrace(new PrintWriter(out, true));
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>
</div>
</body>
</html>
