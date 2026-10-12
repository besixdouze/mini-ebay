package com.example.miniebay_fall2025;

import org.json.JSONObject;

import java.io.Serializable;

public class jsonProduct implements Serializable {

    private int productId;
    private String productName;
    private String description;
    private double currentBid;
    private double startingBid;
    private String dueDate;
    private String imagePath;
    private String deptName;
    private String sellerUserName;

    public jsonProduct(JSONObject jsonObj) {
        try {
            productId = jsonObj.getInt("productId");
            productName = jsonObj.getString("productName");
            description = jsonObj.getString("description");
            currentBid = jsonObj.getDouble("currentBid");
            startingBid = jsonObj.getDouble("startingBid");
            dueDate = jsonObj.getString("dueDate");
            imagePath = jsonObj.optString("imagePath", "");
            deptName = jsonObj.getString("deptName");
            sellerUserName = jsonObj.getString("sellerUserName");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int getProductId() {
        return productId;
    }

    public String getProductName() {
        return productName;
    }

    public String getDescription() {
        return description;
    }

    public double getCurrentBid() {
        return currentBid;
    }

    public double getStartingBid() {
        return startingBid;
    }

    public String getDueDate() {
        return dueDate;
    }

    public String getImagePath() {
        return imagePath;
    }

    public String getDeptName() {
        return deptName;
    }

    public String getSellerUserName() {
        return sellerUserName;
    }
}
