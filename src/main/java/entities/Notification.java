package entities;

import java.sql.Timestamp;

public class Notification {
    private int id;
    private int userId;
    private String title;
    private String message;
    private NotificationType type;
    private RelatedType relatedType;
    private Integer relatedId;
    private boolean isRead;
    private Timestamp readAt;
    private Timestamp createdAt;

    public enum NotificationType {
        INFO, SUCCESS, WARNING, ERROR
    }

    public enum RelatedType {
        BOOKING, PAYMENT, SYSTEM
    }

    public Notification() {}

    public Notification(int userId, String title, String message, NotificationType type) {
        this.userId = userId;
        this.title = title;
        this.message = message;
        this.type = type;
        this.isRead = false;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public NotificationType getType() {
        return type;
    }

    public void setType(NotificationType type) {
        this.type = type;
    }

    public RelatedType getRelatedType() {
        return relatedType;
    }

    public void setRelatedType(RelatedType relatedType) {
        this.relatedType = relatedType;
    }

    public Integer getRelatedId() {
        return relatedId;
    }

    public void setRelatedId(Integer relatedId) {
        this.relatedId = relatedId;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean read) {
        isRead = read;
    }

    public Timestamp getReadAt() {
        return readAt;
    }

    public void setReadAt(Timestamp readAt) {
        this.readAt = readAt;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    // Helper method to get badge class for Bootstrap
    public String getBadgeClass() {
        switch (type) {
            case SUCCESS:
                return "bg-success";
            case WARNING:
                return "bg-warning";
            case ERROR:
                return "bg-danger";
            case INFO:
            default:
                return "bg-info";
        }
    }

    // Helper method to get icon class for Bootstrap Icons
    public String getIconClass() {
        switch (type) {
            case SUCCESS:
                return "bi-check-circle-fill";
            case WARNING:
                return "bi-exclamation-triangle-fill";
            case ERROR:
                return "bi-x-circle-fill";
            case INFO:
            default:
                return "bi-info-circle-fill";
        }
    }
}