package model;

public class Booking {
    private int id;
    private String username;
    private String supplyType;
    private int quantity;
    private String status;
    private String bookingDate;

    public Booking() {}

    public Booking(int id, String username, String supplyType, int quantity, String status, String bookingDate) {
        this.id = id;
        this.username = username;
        this.supplyType = supplyType;
        this.quantity = quantity;
        this.status = status;
        this.bookingDate = bookingDate;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getSupplyType() { return supplyType; }
    public void setSupplyType(String supplyType) { this.supplyType = supplyType; }

    public Integer getQuantity() { return quantity; }
    public void setDestination(String destination) { this.quantity = quantity; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getBookingDate() { return bookingDate; }
    public void setBookingDate(String bookingDate) { this.bookingDate = bookingDate; }
}
