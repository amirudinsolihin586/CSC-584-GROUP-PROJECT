package model;

public class Order {
    private int id;
    private String username;
    private String itemName;
    private int quantity;
    private String status;
    private String orderDate;
    private String location;

    public Order() {}

    public Order(int id, String username, String itemName, int quantity, String status, String orderDate, String location) {
        this.id = id;
        this.username = username;
        this.itemName = itemName;
        this.quantity = quantity;
        this.status = status;
        this.orderDate = orderDate;
        this.location = location;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getOrderDate() { return orderDate; }
    public void setOrderDate(String orderDate) { this.orderDate = orderDate; }
    
    public String getLocation() { return location; }
    public void setLocation(String status) { this.location = status; }
}
