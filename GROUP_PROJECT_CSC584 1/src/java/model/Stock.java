package model;

public class Stock 
{
    private int id;
    private String itemName;
    private String category;
    private int quantity;
    private String location;

    // Getters and setters
    public int getId() 
    {
        return id; 
    }
    public void setId(int id) 
    { 
        this.id = id;
    }

    public String getItemName() 
    { 
        return itemName; 
    }
    public void setItemName(String itemName) 
    { 
        this.itemName = itemName; 
    }

    public String getCategory() 
    { return category; 
    }
    public void setCategory(String category) 
    { 
        this.category = category; 
    }

    public int getQuantity() 
    { 
        return quantity; 
    }
    public void setQuantity(int quantity) 
    { 
        this.quantity = quantity; 
    }

    public String getLocation() 
    { 
        return location; 
    }
    public void setLocation(String location) 
    { 
        this.location = location; 
    }
}
