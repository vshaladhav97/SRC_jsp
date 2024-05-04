package com.db_servlet.web;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
@WebServlet(name = "DbQueryExecuteServlet", urlPatterns = {"/InitializeDatabase"})
public class DbQueryExecuteServelet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().println("<html><head><title>Database Initialization</title></head><body>");

        // Attempt to execute SQL file
        try {
            executeSqlFile(response.getWriter());
            response.getWriter().println("<p>Database setup completed successfully.</p>");
        } catch (Exception e) {
            response.getWriter().println("<p>Error during database setup: " + e.getMessage() + "</p>");
            e.printStackTrace(response.getWriter());
        }

        response.getWriter().println("</body></html>");
    }

    private void executeSqlFile(java.io.PrintWriter out) throws SQLException, IOException {
        InputStream inputStream = getServletContext().getResourceAsStream("/WEB-INF/sql_queries.sql");
        BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));

        try (Connection conn = getDataSource().getConnection();
             Statement stmt = conn.createStatement()) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (!line.isEmpty() && !line.startsWith("--")) { // skip empty lines and comments
                    try {
                        stmt.execute(line);
                        out.println("<p>Executed: " + line + "</p>");
                    } catch (SQLException ex) {
                        out.println("<p>Failed to execute: " + line + " Error: " + ex.getMessage() + "</p>");
                    }
                }
            }
        } finally {
            if (reader != null) reader.close();
        }
    }

    private DataSource getDataSource() throws SQLException {
        oracle.jdbc.pool.OracleDataSource ds = new oracle.jdbc.pool.OracleDataSource();
        ds.setURL("jdbc:oracle:thin:@castor.cc.binghamton.edu:1521:ACAD111");
        ds.setUser("vadhav");  // Adjust with your actual username
        ds.setPassword("Vshaladhav97");  // Adjust with your actual password
        return ds;
    }
}
