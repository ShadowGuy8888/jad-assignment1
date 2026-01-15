package entities;

import java.sql.Timestamp;

public class Booking {
    private int id;
    private int userId;
    private int serviceId;
    private Timestamp checkInTime;
    private int durationHours;
    private double totalPrice;
    private String status;
    private String notes;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Booking() {}
    
    public Booking(int id, int userId, int serviceId, Timestamp checkInTime, int durationHours, double totalPrice, String status, String notes, Timestamp createdAt, Timestamp updatedAt) {
        this.id = id;
    	this.userId = userId;
        this.serviceId = serviceId;
        this.checkInTime = checkInTime;
        this.durationHours = durationHours;
        this.totalPrice = totalPrice;
        this.status = status;
        this.notes = notes;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }

    public Timestamp getCheckInTime() { return checkInTime; }
    public void setCheckInTime(Timestamp checkInTime) { this.checkInTime = checkInTime; }

    public int getDurationHours() { return durationHours; }
    public void setDurationHours(int durationHours) { this.durationHours = durationHours; }

    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}