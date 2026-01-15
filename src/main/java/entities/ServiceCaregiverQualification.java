package entities;

public class ServiceCaregiverQualification {

    private int caregiverQualificationId;
    private int serviceId;

    public ServiceCaregiverQualification() {}

    public int getCaregiverQualificationId() {
        return caregiverQualificationId;
    }

    public void setCaregiverQualificationId(int caregiverQualificationId) {
        this.caregiverQualificationId = caregiverQualificationId;
    }

    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }
}