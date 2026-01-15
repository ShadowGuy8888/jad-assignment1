package daos;

import entities.Notification;
import entities.Notification.NotificationType;
import entities.Notification.RelatedType;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.jovanchunyi.util.DatabaseConnection;

public class NotificationDAO {

    public NotificationDAO() {}

    public boolean createNotification(Notification notification) {
        String sql = "INSERT INTO notification (user_id, title, message, type, related_type, related_id) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (
        	Connection conn = DatabaseConnection.getConnection();
        	PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)
        ) {
            stmt.setInt(1, notification.getUserId());
            stmt.setString(2, notification.getTitle());
            stmt.setString(3, notification.getMessage());
            stmt.setString(4, notification.getType().name());
            
            if (notification.getRelatedType() != null) {
                stmt.setString(5, notification.getRelatedType().name());
            } else {
                stmt.setNull(5, Types.VARCHAR);
            }
            
            if (notification.getRelatedId() != null) {
                stmt.setInt(6, notification.getRelatedId());
            } else {
                stmt.setNull(6, Types.INTEGER);
            }
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        notification.setId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Notification> getNotificationsByUserId(String userId) {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM notification WHERE user_id = ? ORDER BY created_at DESC";
        
        try (
        	Connection conn = DatabaseConnection.getConnection();
        	PreparedStatement stmt = conn.prepareStatement(sql)
        ) {
            stmt.setString(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                notifications.add(mapResultSetToNotification(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return notifications;
    }

    public List<Notification> getUnreadNotifications(String userId) {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM notification WHERE user_id = ? AND is_read = FALSE ORDER BY created_at DESC";
        
        try (
        	Connection conn = DatabaseConnection.getConnection();
        	PreparedStatement stmt = conn.prepareStatement(sql)
        ) {
            stmt.setString(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                notifications.add(mapResultSetToNotification(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return notifications;
    }

    public int getUnreadCount(String userId) {
        String sql = "SELECT COUNT(*) FROM notification WHERE user_id = ? AND is_read = FALSE";
        
        try (
        	Connection conn = DatabaseConnection.getConnection();
        	PreparedStatement stmt = conn.prepareStatement(sql)
        ) {
            stmt.setString(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean markAsRead(String notificationId, String userId) {
        String sql = "{CALL mark_notification_read(?, ?, ?, ?)}";
        
        try (
        	Connection conn = DatabaseConnection.getConnection();
        	CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, Integer.parseInt(notificationId));
            stmt.setInt(2, Integer.parseInt(userId));
            stmt.registerOutParameter(3, Types.BOOLEAN);
            stmt.registerOutParameter(4, Types.VARCHAR);
            
            stmt.execute();
            return stmt.getBoolean(3);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean markAllAsRead(String userId) {
        String sql = "{CALL mark_all_notifications_read(?, ?, ?, ?)}";
        
        try (
        	Connection conn = DatabaseConnection.getConnection();
        	CallableStatement stmt = conn.prepareCall(sql)
        ) {
            stmt.setInt(1, Integer.parseInt(userId));
            stmt.registerOutParameter(2, Types.BOOLEAN);
            stmt.registerOutParameter(3, Types.INTEGER);
            stmt.registerOutParameter(4, Types.VARCHAR);
            
            stmt.execute();
            return stmt.getBoolean(2);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteNotification(String notificationId, String userId) {
        String sql = "DELETE FROM notification WHERE id = ? AND user_id = ?";
        
        try (
        	Connection conn = DatabaseConnection.getConnection();
        	PreparedStatement stmt = conn.prepareStatement(sql)
        ) {
            stmt.setString(1, notificationId);
            stmt.setString(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Helper method to map ResultSet to Notification object
    private Notification mapResultSetToNotification(ResultSet rs) throws SQLException {
        Notification notification = new Notification();
        notification.setId(rs.getInt("id"));
        notification.setUserId(rs.getInt("user_id"));
        notification.setTitle(rs.getString("title"));
        notification.setMessage(rs.getString("message"));
        notification.setType(NotificationType.valueOf(rs.getString("type")));
        
        String relatedTypeStr = rs.getString("related_type");
        if (relatedTypeStr != null) {
            notification.setRelatedType(RelatedType.valueOf(relatedTypeStr));
        }
        
        int relatedId = rs.getInt("related_id");
        if (!rs.wasNull()) {
            notification.setRelatedId(relatedId);
        }
        
        notification.setRead(rs.getBoolean("is_read"));
        notification.setReadAt(rs.getTimestamp("read_at"));
        notification.setCreatedAt(rs.getTimestamp("created_at"));
        
        return notification;
    }
}
