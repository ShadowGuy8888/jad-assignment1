package daos;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.jovanchunyi.util.DatabaseConnection;

import entities.Booking;

// ALL ID PARAMETERS MUST BE TYPE STRING
public class BookingDAO {
	
	public String getServiceIdByBookingId(String bookingId) throws SQLException {
		try (
			Connection conn = DatabaseConnection.getConnection();
			PreparedStatement ps = conn.prepareStatement("SELECT service_id FROM booking WHERE id = ?");
		) {
			ps.setString(1, bookingId);
			try (ResultSet rs = ps.executeQuery()) {
				if (!rs.next()) return null;
				else return rs.getString("service_id");
			}
		}
	}
	
    public Booking findByIdAndUser(String bookingId, String userId) throws SQLException {
        try (
        	Connection conn = DatabaseConnection.getConnection();
			PreparedStatement ps = conn.prepareStatement("""
	            SELECT b.*, s.name AS service_name, s.hourly_rate
	            FROM booking b
	            JOIN service s ON b.service_id = s.id
	            WHERE b.id = ? AND b.user_id = ?
			""")
		) {
            ps.setString(1, bookingId);
            ps.setString(2, userId);
            ResultSet rs = ps.executeQuery();
            
            if (!rs.next()) return null;

            Booking b = new Booking();
            b.setId(rs.getInt("id"));
            b.setUserId(Integer.parseInt(userId));
            b.setServiceId(rs.getInt("service_id"));
            b.setCheckInTime(rs.getTimestamp("check_in_time"));
            b.setDurationHours(rs.getInt("duration_hours"));
            b.setTotalPrice(rs.getDouble("total_price"));
            b.setStatus(rs.getString("status"));
            b.setNotes(rs.getString("notes"));
            b.setCreatedAt(rs.getTimestamp("created_at"));
            b.setUpdatedAt(rs.getTimestamp("updated_at"));
            return b;
        }
    }

    public boolean createBooking(Booking booking) throws SQLException {
        try (
        	Connection conn = DatabaseConnection.getConnection();
        	PreparedStatement ps = conn.prepareStatement("INSERT INTO booking (user_id, service_id, check_in_time, duration_hours, total_price, notes) VALUES (?, ?, ?, ?, ?, ?)")
        ) {
            ps.setInt(1, booking.getUserId());
            ps.setInt(2, booking.getServiceId());
            ps.setTimestamp(3, booking.getCheckInTime());
            ps.setInt(4, booking.getDurationHours());
            ps.setDouble(5, booking.getTotalPrice());
            ps.setString(6, booking.getNotes());
            return ps.executeUpdate() > 0;
        }
    }
    
    public boolean updateBooking(Timestamp checkInTime, int durationHours, Double totalPrice, String notes, String bookingId, String userId) throws SQLException {
        try (
        	Connection conn = DatabaseConnection.getConnection();
        	PreparedStatement ps = conn.prepareStatement("""
                UPDATE booking
                SET check_in_time = ?, duration_hours = ?, total_price = ?, notes = ?, updated_at = NOW()
                WHERE id = ? AND user_id = ? AND status = 'PENDING'
            """)
        ) {
            ps.setTimestamp(1, checkInTime);
            ps.setDouble(2, durationHours);
            ps.setDouble(3, totalPrice);
            ps.setString(4, notes);
            ps.setString(5, bookingId);
            ps.setString(6, userId);
            return ps.executeUpdate() > 0;
        }
    }

    // Get price of a service
    public double getServicePrice(String serviceId) throws SQLException {
        double price = 0.0;
        String query = "SELECT hourly_rate FROM service WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, serviceId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) price = rs.getDouble("hourly_rate");
        }
        return price;
    }
    
    public int getActiveBookingCount() throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM booking WHERE status = 'CONFIRMED'";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt("count");
            }
            return 0;
        }
    }
    
    public double getTotalRevenue() throws SQLException {
        String sql = "SELECT COALESCE(SUM(total_price), 0) as revenue FROM booking WHERE status = 'COMPLETED'";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getDouble("revenue");
            }
            return 0.0;
        }
    }
    
    public List<Booking> getAllBookings() throws SQLException {
        String sql = "SELECT b.*, s.name as service_name, s.hourly_rate, c.name as category_name " +
                    "FROM booking b " +
                    "JOIN service s ON b.service_id = s.id " +
                    "JOIN service_category c ON s.category_id = c.id " +
                    "ORDER BY b.check_in_time DESC";
        
        List<Booking> bookings = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                bookings.add(mapResultSetToBooking(rs));
            }
        }
        return bookings;
    }
    
    public boolean cancelBooking(String bookingId, String userId) throws SQLException {
        String sql = "UPDATE booking SET status = 'CANCELLED', updated_at = NOW() WHERE id = ? AND user_id = ? AND status = 'PENDING'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, bookingId);
            ps.setString(2, userId);
            return ps.executeUpdate() > 0;
        }
    }
    
    public List<java.util.Map<String, Object>> getPendingBookingsByUser(String userId) throws SQLException {
        String sql = """
            SELECT b.id, s.name AS service_name, b.check_in_time, b.duration_hours, b.total_price, b.status, b.notes
            FROM booking b
            JOIN service s ON b.service_id = s.id
            WHERE b.status = 'PENDING' AND b.user_id = ?
            ORDER BY b.check_in_time DESC
        """;
        List<java.util.Map<String, Object>> items = new ArrayList<>();
        try (
            Connection conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    java.util.Map<String, Object> row = new java.util.HashMap<>();
                    row.put("id", rs.getString("id"));
                    row.put("serviceName", rs.getString("service_name"));
                    row.put("bookingTimestamp", rs.getTimestamp("check_in_time"));
                    row.put("duration", rs.getInt("duration_hours"));
                    row.put("totalPrice", rs.getDouble("total_price"));
                    row.put("statusClass", rs.getString("status").toLowerCase());
                    row.put("notes", rs.getString("notes"));
                    items.add(row);
                }
            }
        }
        return items;
    }
    
    public boolean deletePendingBooking(String bookingId, String userId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);
            ps = conn.prepareStatement("DELETE FROM booking WHERE id = ? AND user_id = ? AND status = 'PENDING'");
            ps.setString(1, bookingId);
            ps.setString(2, userId);
            int affected = ps.executeUpdate();
            conn.commit();
            return affected > 0;
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
    }
    
    private Booking mapResultSetToBooking(ResultSet rs) throws SQLException {
        Booking b = new Booking();
        b.setId(rs.getInt("id"));
        b.setUserId(rs.getInt("user_id"));
        b.setServiceId(rs.getInt("service_id"));
        b.setCheckInTime(rs.getTimestamp("check_in_time"));
        b.setDurationHours(rs.getInt("duration_hours"));
        b.setTotalPrice(rs.getDouble("total_price"));
        b.setStatus(rs.getString("status"));
        b.setNotes(rs.getString("notes"));
        b.setCreatedAt(rs.getTimestamp("created_at"));
        b.setUpdatedAt(rs.getTimestamp("updated_at"));
        return b;
    }
}
