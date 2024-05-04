<%@ page import="java.sql.*" %>
<%@ page import="oracle.jdbc.pool.OracleDataSource" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Manage Classes</title>
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
<h1>Manage Classes</h1>
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
<form method="GET" action="classes.jsp">
    <label for="action">Choose an action:</label>
    <select name="action" id="action" onchange="this.form.submit()">
        <option value="">Select...</option>
        <option value="view_classes" <%= "view_classes".equals(action) ? "selected" : "" %>>View All Classes</option>
        <option value="add_class" <%= "add_class".equals(action) ? "selected" : "" %>>Add New Class</option>
        <option value="delete_class" <%= "delete_class".equals(action) ? "selected" : "" %>>Delete a Class</option>
    </select>
</form>

<%
        if ("view_classes".equals(action)) {
            pstmt = conn.prepareStatement("SELECT classid, dept_code, course#, sect#, year, semester, limit, class_size, room FROM classes ORDER BY dept_code, course#, sect#");
            rs = pstmt.executeQuery();
            if (!rs.isBeforeFirst()) {
                out.println("<p>No classes found.</p>");
            } else {
                out.println("<table border='1'><tr><th>Class ID</th><th>Dept Code</th><th>Course Number</th><th>Section</th><th>Year</th><th>Semester</th><th>Limit</th><th>Class Size</th><th>Room</th></tr>");
                while (rs.next()) {
                    out.println("<tr><td>" + rs.getString("classid") + "</td><td>" + rs.getString("dept_code") + "</td><td>" + rs.getInt("course#") + "</td><td>" + rs.getInt("sect#") + "</td><td>" + rs.getInt("year") + "</td><td>" + rs.getString("semester") + "</td><td>" + rs.getInt("limit") + "</td><td>" + rs.getInt("class_size") + "</td><td>" + rs.getString("room") + "</td></tr>");
                }
                out.println("</table>");
            }
        } else if ("add_class".equals(action)) {
%>
<form method="POST" action="classes.jsp?action=insert">
    Class ID: <input type="text" name="classid" required><br>
    Dept Code: <input type="text" name="dept_code" required><br>
    Course Number: <input type="text" name="course_number" required><br>
    Section Number: <input type="text" name="sect_number" required><br>
    Year: <input type="text" name="year" required><br>
    Semester: <input type="text" name="semester" required><br>
    Limit: <input type="text" name="limit" required><br>
    Class Size: <input type="text" name="class_size" required><br>
    Room: <input type="text" name="room" required><br>
    <input type="submit" value="Add Class">
</form>
<%
        } else if ("insert".equals(action)) {
            String classid = request.getParameter("classid");
            String deptCode = request.getParameter("dept_code");
            int courseNumber = Integer.parseInt(request.getParameter("course_number"));
            int sectNumber = Integer.parseInt(request.getParameter("sect_number"));
            int year = Integer.parseInt(request.getParameter("year"));
            String semester = request.getParameter("semester");
            int limit = Integer.parseInt(request.getParameter("limit"));
            int classSize = Integer.parseInt(request.getParameter("class_size"));
            String room = request.getParameter("room");

            pstmt = conn.prepareStatement("INSERT INTO classes (classid, dept_code, course#, sect#, year, semester, limit, class_size, room) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
            pstmt.setString(1, classid);
            pstmt.setString(2, deptCode);
            pstmt.setInt(3, courseNumber);
            pstmt.setInt(4, sectNumber);
            pstmt.setInt(5, year);
            pstmt.setString(6, semester);
            pstmt.setInt(7, limit);
            pstmt.setInt(8, classSize);
            pstmt.setString(9, room);
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                out.println("<p>Class added successfully!</p>");
            } else {
                out.println("<p>Error adding class.</p>");
            }
        } else if ("delete_class".equals(action)) {
%>
<form method="POST" action="classes.jsp?action=delete">
    Class ID: <input type="text" name="classid" required><br>
    <input type="submit" value="Delete Class">
</form>
<%
        } else if ("delete".equals(action)) {
            String classid = request.getParameter("classid");
            pstmt = conn.prepareStatement("DELETE FROM classes WHERE classid = ? AND NOT EXISTS (SELECT 1 FROM g_enrollments WHERE classid = ?)");
            pstmt.setString(1, classid);
            pstmt.setString(2, classid);
            int count = pstmt.executeUpdate();
            if (count > 0) {
                out.println("<p>Class deleted successfully!</p>");
            } else {
                out.println("<p>Class not found or could not be deleted due to existing enrollments.</p>");
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
