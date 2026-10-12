package com.example.miniebay_fall2025;

import org.json.JSONObject;

import java.io.Serializable;

public class jsonDepartment implements Serializable {

    private int deptId;
    private String deptName;
    private String description;

    public jsonDepartment(JSONObject jsonObj) {
        try {
            deptId = jsonObj.getInt("deptId");
            deptName = jsonObj.getString("deptName");
            description = jsonObj.optString("description", "");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int getDeptId() {
        return deptId;
    }

    public String getDeptName() {
        return deptName;
    }

    public String getDescription() {
        return description;
    }

    @Override
    public String toString() {
        return deptName;
    }
}
