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
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #eceff1;
            color: #424242;
            line-height: 1.6;
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
        select option {
    		padding: 10px;
    		background: #fff;
    		color: #333;
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
        
        table {
            width: 100%;
            margin-top: 10px;
            border-collapse: collapse;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th {
            height: 50px;
            background-color: #009688;
            color: #fff;
            text-transform: uppercase;
        }
        td {
            height: 50px;
            padding: 5px;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
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
<form method="POST" action="students.jsp?action=insert_student">
   B#: <input type="text" name="B#" placeholder="B# (e.g., B00000001)" required>
   First Name: <input type="text" name="first_name" placeholder="First Name" required>
   Last Name: <input type="text" name="last_name" placeholder="Last Name" required>
   Level: <input type="text" name="st_level" placeholder="Level (e.g., freshman)" required>
   GPA:	<input type="text" name="gpa" placeholder="GPA" required>
   Email: <input type="text" name="email" placeholder="Email" required>
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
%>
<form method="GET" action="students.jsp?action=select_for_edit">
    B#: <input type="text" name="B#" placeholder="Enter B# to Edit" required><br>
    <input type="submit" value="Edit Student">
</form>
<%
        } else if ("select_for_edit".equals(action)) {
            String bNo = request.getParameter("B#");
            pstmt = conn.prepareStatement("SELECT * FROM students WHERE B# = ?");
            pstmt.setString(1, bNo);
            rs = pstmt.executeQuery();
            if (rs.next()) {
%>
<form method="POST" action="students.jsp?action=update_student">
    <input type="hidden" name="B#" value="<%= rs.getString("B#") %>">
    First Name: <input type="text" name="first_name" value="<%= rs.getString("first_name") %>" required><br>
    Last Name: <input type="text" name="last_name" value="<%= rs.getString("last_name") %>" required><br>
    Level: <input type="text" name="st_level" value="<%= rs.getString("st_level") %>" required><br>
    GPA: <input type="text" name="gpa" value="<%= rs.getDouble("gpa") %>" required><br>
    Email: <input type="text" name="email" value="<%= rs.getString("email") %>" required><br>
    <input type="submit" value="Update Student">
</form>
<%
            } else {
                out.println("<p>No student found with B# " + bNo + ".</p>");
            }
        } else if ("delete_student".equals(action)) {
%>
<form method="POST" action="students.jsp?action=remove_student">
    B#: <input type="text" name="B#" placeholder="Enter B# to Delete" required><br>
    <input type="submit" value="Delete Student">
</form>
<%
        } else if ("remove_student".equals(action)) {
            String bNo = request.getParameter("B#");
            pstmt = conn.prepareStatement("DELETE FROM students WHERE B# = ?");
            pstmt.setString(1, bNo);
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                out.println("<p>Student deleted successfully.</p>");
            } else {
                out.println("<p>Error deleting student or student not found.</p>");
            }
        }
    } catch (SQLException e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
        e.printStackTrace(new PrintWriter(out, true));
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (cstmt != null) cstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException ex) {
            out.println("<p>Error in closing resources: " + ex.getMessage() + "</p>");
        }
    }
%>
</div>
</body>
</html>
