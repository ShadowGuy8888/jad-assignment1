package daos;

import entities.Service;
import com.jovanchunyi.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ServiceDAO {
    
    public Service findById(String id) throws SQLException {
        String sql = "SELECT * FROM service WHERE id = ? AND deleted_at IS NULL";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToService(rs);
            }
            return null;
        }
    }
    
    public List<Service> findAll() throws SQLException {
        String sql = "SELECT * FROM service WHERE deleted_at IS NULL ORDER BY name";
        List<Service> services = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                services.add(mapResultSetToService(rs));
            }
        }
        return services;
    }
    
    public List<Service> findByCategory(String categoryId) throws SQLException {
        String sql = "SELECT * FROM service WHERE category_id = ? AND deleted_at IS NULL ORDER BY name";
        List<Service> services = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, categoryId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                services.add(mapResultSetToService(rs));
            }
        }
        return services;
    }
    
    public boolean create(Service service) throws SQLException {
        String sql = "INSERT INTO service (name, description, hourly_rate, image_url, category_id) " +
                    "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, service.getName());
            stmt.setString(2, service.getDescription());
            stmt.setInt(3, service.getHourlyRate());
            stmt.setString(4, service.getImageUrl());
            stmt.setInt(5, service.getCategoryId());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    service.setId(generatedKeys.getInt(1));
                }
                return true;
            }
            return false;
        }
    }
    
    public boolean update(Service service) throws SQLException {
        String sql = "UPDATE service SET name = ?, description = ?, hourly_rate = ?, " +
                    "image_url = ?, category_id = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, service.getName());
            stmt.setString(2, service.getDescription());
            stmt.setInt(3, service.getHourlyRate());
            stmt.setString(4, service.getImageUrl());
            stmt.setInt(5, service.getCategoryId());
            stmt.setInt(6, service.getId());
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    public boolean delete(String id) throws SQLException {
        String sql = "UPDATE service SET deleted_at = NOW() WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, id);
            return stmt.executeUpdate() > 0;
        }
    }
    
    public double getHourlyRate(String serviceId) throws SQLException {
        String sql = "SELECT hourly_rate FROM service WHERE id = ? AND deleted_at IS NULL";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, serviceId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble("hourly_rate");
            }
            return 0.0;
        }
    }
    
    public boolean exists(String id) throws SQLException {
        String sql = "SELECT COUNT(*) FROM service WHERE id = ? AND deleted_at IS NULL";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        }
    }
    
    private Service mapResultSetToService(ResultSet rs) throws SQLException {
        Service service = new Service();
        service.setId(rs.getInt("id"));
        service.setName(rs.getString("name"));
        service.setDescription(rs.getString("description"));
        service.setHourlyRate(rs.getInt("hourly_rate"));
        service.setImageUrl(rs.getString("image_url"));
        service.setCategoryId(rs.getInt("category_id"));
        service.setDeletedAt(rs.getTimestamp("deleted_at"));
        return service;
    }
    
    public int getActiveServiceCount() throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM service WHERE deleted_at IS NULL";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt("count");
            }
            return 0;
        }
    }
    
    public List<Service> getAllServicesExcludingDeleted() throws SQLException {
        String sql = "SELECT s.*, c.name as category_name " +
                    "FROM service s " +
                    "JOIN service_category c ON s.category_id = c.id " +
                    "WHERE s.deleted_at IS NULL";
        
        List<Service> services = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Service service = mapResultSetToService(rs);
                // Set category name if needed (you might want to add this to Service entity)
                services.add(service);
            }
        }
        return services;
    }
}
