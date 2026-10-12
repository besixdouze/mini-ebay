package com.example.miniebay_fall2025;

import org.json.JSONObject;

import java.io.Serializable;

public class jsonPerson implements Serializable {

    private String name;
    private String email;
    private String userName;
    private String id;
    private String role;

    public jsonPerson(String id, String name, String email, String userName) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.userName = userName;
    }

    public jsonPerson(String jsonFile) {
        try {
            JSONObject jsonObj = new JSONObject(jsonFile);
            id = jsonObj.getString("id");
            name = jsonObj.getString("name");
            userName = jsonObj.getString("userName");
            email = jsonObj.getString("email");
            if (jsonObj.has("role")) {
                role = jsonObj.getString("role");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String getName() {
        return name;
    }

    public String getEmail() {
        return email;
    }

    public String getUserName() {
        return userName;
    }

    public String getId() {
        return id;
    }

    public String getRole() {
        return role;
    }
}
