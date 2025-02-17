package com.todo.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import com.todo.utils.DbCon;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AddTaskServlet")
public class AddTask extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String dueDate = request.getParameter("due_date");

        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DbCon.getConnection();
            if (conn == null) {
                throw new SQLException("Database connection failed.");
            }

            String sql = "INSERT INTO tasks (title, description, due_date) VALUES (?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, title);
            stmt.setString(2, description);
            
            // If dueDate is empty, set NULL in the database
            if (dueDate == null || dueDate.isEmpty()) {
                stmt.setNull(3, java.sql.Types.DATE);
            } else {
                stmt.setString(3, dueDate);
            }
            
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error adding task: " + e.getMessage());
            return;
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        response.sendRedirect("index.jsp");
    }
}
