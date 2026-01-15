package entities;

import java.sql.Timestamp;

public class Payment {

    private int id;
    private int bookingId;
    private int amountSettlement;
    private String currencySettlement;
    private Integer amountPresentment;
    private String currencyPresentment;
    private Integer feeTotal;
    private Double exchangeRate;
    private String status;
    private String stripePaymentIntentId;
    private String stripeChargeId;
    private String stripeRefundId;
    private Timestamp paidAt;
    private Timestamp refundedAt;
    private Timestamp createdAt;

    public Payment() {}

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public int getAmountSettlement() {
        return amountSettlement;
    }

    public void setAmountSettlement(int amountSettlement) {
        this.amountSettlement = amountSettlement;
    }

    public String getCurrencySettlement() {
        return currencySettlement;
    }

    public void setCurrencySettlement(String currencySettlement) {
        this.currencySettlement = currencySettlement;
    }

    public Integer getAmountPresentment() {
        return amountPresentment;
    }

    public void setAmountPresentment(Integer amountPresentment) {
        this.amountPresentment = amountPresentment;
    }

    public String getCurrencyPresentment() {
        return currencyPresentment;
    }

    public void setCurrencyPresentment(String currencyPresentment) {
        this.currencyPresentment = currencyPresentment;
    }

    public Integer getFeeTotal() {
        return feeTotal;
    }

    public void setFeeTotal(Integer feeTotal) {
        this.feeTotal = feeTotal;
    }

    public Double getExchangeRate() {
        return exchangeRate;
    }

    public void setExchangeRate(Double exchangeRate) {
        this.exchangeRate = exchangeRate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStripePaymentIntentId() {
        return stripePaymentIntentId;
    }

    public void setStripePaymentIntentId(String stripePaymentIntentId) {
        this.stripePaymentIntentId = stripePaymentIntentId;
    }

    public String getStripeChargeId() {
        return stripeChargeId;
    }

    public void setStripeChargeId(String stripeChargeId) {
        this.stripeChargeId = stripeChargeId;
    }

    public String getStripeRefundId() {
        return stripeRefundId;
    }

    public void setStripeRefundId(String stripeRefundId) {
        this.stripeRefundId = stripeRefundId;
    }

    public Timestamp getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(Timestamp paidAt) {
        this.paidAt = paidAt;
    }

    public Timestamp getRefundedAt() {
        return refundedAt;
    }

    public void setRefundedAt(Timestamp refundedAt) {
        this.refundedAt = refundedAt;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}