<html>
<head>
<title>University Management System</title>
<style>
        body {
            font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
            background-color: #e0e0e0;
            color: #333;
            line-height: 1.6;
            padding: 10px;
            margin: 0;
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
            margin-bottom: 30px;
        }
        ul {
            list-style: none;
            padding: 0;
        }
        ul li {
            background-color: #f9f9f9;
            border: 1px solid #ddd;
            margin-bottom: 5px;
            padding: 10px;
            border-radius: 4px;
            transition: background-color 0.3s ease;
        }
        ul li a {
            text-decoration: none;
            color: #333;
            display: block;
            transition: color 0.3s ease;
        }
        ul li:hover {
            background-color: #f5f5f5;
        }
        ul li a:hover {
            color: #007bff;
        }
        li : hover {
        	box-shadow: 0px 0px 10px rgba(0,0,0,0.2);
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
<h1>Welcome to the Student Registration System</h1>
<ul>
    <li><a href="students.jsp">Manage Students</a></li>
    <li><a href="courses.jsp">Manage Courses</a></li>
    <li><a href="classes.jsp">Manage Classes</a></li>
    <li><a href="enrollments.jsp">Manage Enrollments</a></li>
    <li><a href="logs.jsp">View Logs</a></li>
    <li><a href="lookupClass.jsp">3 Proc</a></li>
    <li><a href="viewCoursePrerequisites.jsp">4 Proc</a>
    <li><a href="enrollGrad.jsp">5 Proc</a>
    <li><a href="dropGrad.jsp">6 Proc</a>
    <li><a href="deleteStudent.jsp">7 Proc</a>
</ul>
</div>
</body>
</html>
