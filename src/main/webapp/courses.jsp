<%@ page import="java.sql.*" %>
<%@ page import="oracle.jdbc.pool.OracleDataSource" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Manage Courses</title>
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
<h1>Manage Courses</h1>
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
<form method="GET" action="courses.jsp">
    <label for="action">Choose an action:</label>
    <select name="action" id="action" onchange="this.form.submit()">
        <option value="">Select...</option>
        <option value="view_courses" <%= "view_courses".equals(action) ? "selected" : "" %>>View All Courses</option>
        <option value="add_course" <%= "add_course".equals(action) ? "selected" : "" %>>Add New Course</option>
        <option value="delete_course" <%= "delete_course".equals(action) ? "selected" : "" %>>Delete a Course</option>
    </select>
</form>

<%
        if ("view_courses".equals(action)) {
            pstmt = conn.prepareStatement("SELECT dept_code, course# as course_number, title FROM courses ORDER BY dept_code, course_number");
            rs = pstmt.executeQuery();
            if (!rs.isBeforeFirst()) {
                out.println("<p>No courses found.</p>");
            } else {
                out.println("<table border='1'><tr><th>Dept Code</th><th>Course Number</th><th>Title</th></tr>");
                while (rs.next()) {
                    out.println("<tr><td>" + rs.getString("dept_code") + "</td><td>" + rs.getInt("course_number") + "</td><td>" + rs.getString("title") + "</td></tr>");
                }
                out.println("</table>");
            }
        } else if ("add_course".equals(action)) {
%>
<form method="POST" action="courses.jsp?action=insert">
    Dept Code: <input type="text" name="dept_code" required><br>
    Course Number: <input type="text" name="course_number" required><br>
    Title: <input type="text" name="title" required><br>
    <input type="submit" value="Add Course">
</form>
<%
        } else if ("insert".equals(action)) {
            String deptCode = request.getParameter("dept_code");
            int courseNumber = Integer.parseInt(request.getParameter("course_number"));
            String title = request.getParameter("title");
            pstmt = conn.prepareStatement("INSERT INTO courses (dept_code, course#, title) VALUES (?, ?, ?)");
            pstmt.setString(1, deptCode);
            pstmt.setInt(2, courseNumber);
            pstmt.setString(3, title);
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                out.println("<p>Course added successfully!</p>");
            } else {
                out.println("<p>Error adding course.</p>");
            }
        } else if ("delete_course".equals(action)) {
%>
<form method="POST" action="courses.jsp?action=delete">
    Dept Code: <input type="text" name="dept_code" required><br>
    Course Number: <input type="text" name="course_number" required><br>
    <input type="submit" value="Delete Course">
</form>
<%
        } else if ("delete".equals(action)) {
            String deptCode = request.getParameter("dept_code");
            int courseNumber = Integer.parseInt(request.getParameter("course_number"));
            pstmt = conn.prepareStatement("DELETE FROM courses WHERE dept_code = ? AND course# = ?");
            pstmt.setString(1, deptCode);
            pstmt.setInt(2, courseNumber);
            int count = pstmt.executeUpdate();
            if (count > 0) {
                out.println("<p>Course deleted successfully!</p>");
            } else {
                out.println("<p>Course not found or could not be deleted.</p>");
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
