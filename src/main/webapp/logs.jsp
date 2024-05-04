<%@ page import="java.sql.*" %>
<%@ page import="oracle.jdbc.pool.OracleDataSource" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>View Logs</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f5f5f5;
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
            color: #333;
            text-align: center;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
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
            color: #d33;
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
<h1>System Logs</h1>
<%
    OracleDataSource ds = new OracleDataSource();
    ds.setURL("jdbc:oracle:thin:@castor.cc.binghamton.edu:1521:ACAD111");
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    try {
        conn = ds.getConnection("vadhav", "Vshaladhav97");
        stmt = conn.createStatement();
        rs = stmt.executeQuery("SELECT LOG#, USER_NAME, OPERATION, OP_TIME, TABLE_NAME, TUPLE_KEYVALUE FROM logs ORDER BY OP_TIME DESC");
        if (!rs.isBeforeFirst()) {
            out.println("<p>No logs found.</p>");
        } else {
            out.println("<table border='1'><tr><th>Log ID</th><th>User Name</th><th>Operation</th><th>Timestamp</th><th>Table Name</th><th>Details</th></tr>");
            while (rs.next()) {
                out.println("<tr><td>" + rs.getInt("LOG#") + "</td><td>" + rs.getString("USER_NAME") + "</td><td>" + rs.getString("OPERATION") + "</td><td>" + rs.getTimestamp("OP_TIME") + "</td><td>" + rs.getString("TABLE_NAME") + "</td><td>" + rs.getString("TUPLE_KEYVALUE") + "</td></tr>");
            }
            out.println("</table>");
        }
    } catch (SQLException e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
        e.printStackTrace(new PrintWriter(out, true));
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>
</div>
</body>
</html>
