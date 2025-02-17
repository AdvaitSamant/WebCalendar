<%@ page import="java.sql.*" %>
<%@ page import="com.todo.utils.DbCon" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>To-Do List</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { background-color: #121212; color: white; }
        .container { max-width: 600px; }
        .form-control, .btn { border-radius: 8px; }
        .list-group-item { background-color: #1e1e1e; color: white; border-color: #333; }
    </style>
</head>
<body class="container mt-5">
    <h2 class="mb-4">📌 To-Do List</h2>
    <form action="AddTaskServlet" method="post">
        <input type="text" name="title" class="form-control mb-2" placeholder="Task Title" required>
        <textarea name="description" class="form-control mb-2" placeholder="Task Description"></textarea>
        <input type="date" name="due_date" class="form-control mb-2">
        <button type="submit" class="btn btn-primary">Add Task</button>
    </form>
    <h3 class="mt-4">Tasks</h3>
    <ul class="list-group">
        <% 
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DbCon.getConnection();
            if (conn == null) {
                throw new SQLException("Database connection failed. Please check your database credentials and server status.");
            }
            String query = "SELECT id, title, description, due_date FROM tasks ORDER BY id DESC";
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            boolean hasTasks = false;
            while (rs.next()) { 
                hasTasks = true; 
                String dueDate = rs.getString("due_date");
                if (dueDate == null || dueDate.isEmpty()) {
                    dueDate = "No Due Date";
                }
        %>
                <li class="list-group-item d-flex justify-content-between">
                    <span><strong><%= rs.getString("title") %></strong> - <%= rs.getString("description") %> (Due: <%= dueDate %>)</span>
                    <a href="DeleteTaskServlet?id=<%= rs.getInt("id") %>" class="btn btn-danger btn-sm">Delete</a>
                </li>
        <% } 
            if (!hasTasks) { %>
                <li class="list-group-item text-center">No tasks available</li>
        <% }
        } catch (SQLException e) { %>
            <li class="list-group-item text-center text-danger">Database Error: <%= e.getMessage() %></li>
        <% e.printStackTrace(); 
        } catch (Exception e) { %>
            <li class="list-group-item text-center text-danger">Unexpected Error: <%= e.getMessage() %></li>
        <% e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) { %>
                <li class="list-group-item text-center text-danger">Error closing database resources: <%= e.getMessage() %></li>
        <% e.printStackTrace(); }
        }
        %>
    </ul>
</body>
</html>
