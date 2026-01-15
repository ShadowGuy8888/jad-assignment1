package daos;

import entities.User;
import com.jovanchunyi.util.DatabaseConnection;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    
    public boolean changePassword(int userId, String currentPassword, String newPassword) throws SQLException {
        User user = findById(userId);
        if (user == null) return false;
        String existingHash = user.getPassword();
        if (existingHash == null || !BCrypt.checkpw(currentPassword, existingHash)) return false;
        String newHash = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        return updatePassword(userId, newHash);
    }
    
    public boolean changePassword(String userId, String currentPassword, String newPassword) throws SQLException {
        User user = findById(Integer.parseInt(userId));
        if (user == null) return false;
        String existingHash = user.getPassword();
        if (existingHash == null || !BCrypt.checkpw(currentPassword, existingHash)) return false;
        String newHash = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        return updatePassword(Integer.parseInt(userId), newHash);
    }
    
    public boolean deleteUser(int id) throws SQLException {
        return delete(id);
    }
    
    public boolean deleteUser(String id) throws SQLException {
        return delete(Integer.parseInt(id));
    }
    
    public boolean updateUser(User user) throws SQLException {
        return update(user);
    }
    
    public boolean updateUserWithPassword(User user, String newPassword) throws SQLException {
        String newHash = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        boolean pwdUpdated = updatePassword(user.getId(), newHash);
        boolean dataUpdated = update(user);
        return pwdUpdated && dataUpdated;
    }
    
    public User findByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM user WHERE username = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
            return null;
        }
    }
    
    public User findById(int id) throws SQLException {
        String sql = "SELECT * FROM user WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
            return null;
        }
    }
    
    public List<User> findAll() throws SQLException {
        String sql = "SELECT * FROM user ORDER BY created_at DESC";
        List<User> users = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        }
        return users;
    }
    
    public boolean create(User user) throws SQLException {
        String sql = "INSERT INTO user (role, username, password, email, first_name, last_name, phone, " +
                    "address, emergency_contact, blk_no, unit_no, created_at, updated_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, user.getRole());
            stmt.setString(2, user.getUsername());
            stmt.setString(3, user.getPassword()); // Should be hashed before calling this
            stmt.setString(4, user.getEmail());
            stmt.setString(5, user.getFirstName());
            stmt.setString(6, user.getLastName());
            stmt.setString(7, user.getPhone());
            stmt.setString(8, user.getAddress());
            stmt.setString(9, user.getEmergencyContact());
            stmt.setString(10, user.getBlkNo());
            stmt.setString(11, user.getUnitNo());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    user.setId(generatedKeys.getInt(1));
                }
                return true;
            }
            return false;
        }
    }
    
    public boolean update(User user) throws SQLException {
        String sql = "UPDATE user SET username = ?, email = ?, first_name = ?, last_name = ?, " +
                    "phone = ?, updated_at = NOW() WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
        	stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getFirstName());
            stmt.setString(4, user.getLastName());
            stmt.setString(5, user.getPhone());
            stmt.setInt(6, user.getId());
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    public boolean updatePassword(int userId, String hashedPassword) throws SQLException {
        String sql = "UPDATE user SET password = ?, updated_at = NOW() WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, hashedPassword);
            stmt.setInt(2, userId);
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM user WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }
    
    public boolean usernameExists(String username) throws SQLException {
        String sql = "SELECT COUNT(*) FROM user WHERE username = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        }
    }
    
    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM user WHERE email = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        }
    }
    
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setRole(rs.getString("role"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setEmail(rs.getString("email"));
        user.setFirstName(rs.getString("first_name"));
        user.setLastName(rs.getString("last_name"));
        user.setPhone(rs.getString("phone"));
        user.setAddress(rs.getString("address"));
        user.setEmergencyContact(rs.getString("emergency_contact"));
        user.setBlkNo(rs.getString("blk_no"));
        user.setUnitNo(rs.getString("unit_no"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setUpdatedAt(rs.getTimestamp("updated_at"));
        return user;
    }
    
    public int getUserCountByRole(String role) throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM user WHERE role = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, role);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
            return 0;
        }
    }
    
    public List<User> getUsersByRole(String role) throws SQLException {
        String sql = "SELECT * FROM user WHERE role = ? ORDER BY first_name, last_name";
        List<User> users = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, role);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        }
        return users;
    }
}
