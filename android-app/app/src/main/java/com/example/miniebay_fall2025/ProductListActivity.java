package com.example.miniebay_fall2025;

import androidx.appcompat.app.AppCompatActivity;

import android.app.Activity;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;

public class ProductListActivity extends AppCompatActivity {

    public Activity activity;
    protected String hostAddress = "10.0.2.2:8080";
    private jsonPerson currentUser;
    private ListView productListView;
    private Spinner departmentSpinner;
    private EditText searchEditText;
    private ArrayList<jsonProduct> productList;
    private ArrayList<jsonDepartment> departmentList;
    private ProductAdapter productAdapter;
    private int selectedDeptId = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_product_list);

        activity = this;

        Intent i = getIntent();
        currentUser = (jsonPerson) i.getSerializableExtra("jPerson");

        TextView welcomeText = findViewById(R.id.textWelcome);
        welcomeText.setText("Welcome " + currentUser.getName());

        productListView = findViewById(R.id.listViewProducts);
        departmentSpinner = findViewById(R.id.spinnerDepartment);
        searchEditText = findViewById(R.id.editSearch);
        Button searchButton = findViewById(R.id.buttonSearch);

        productList = new ArrayList<>();
        departmentList = new ArrayList<>();

        new LoadDepartments(activity).execute();
        new LoadProducts(activity).execute();

        searchButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String searchTerm = searchEditText.getText().toString();
                new SearchProducts(activity, searchTerm, selectedDeptId).execute();
            }
        });

        departmentSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                if (position == 0) {
                    selectedDeptId = 0;
                } else {
                    selectedDeptId = departmentList.get(position - 1).getDeptId();
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {
                selectedDeptId = 0;
            }
        });

        productListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                jsonProduct selectedProduct = productList.get(position);
                Intent detailIntent = new Intent(ProductListActivity.this, ProductDetailActivity.class);
                detailIntent.putExtra("productId", selectedProduct.getProductId());
                detailIntent.putExtra("jPerson", currentUser);
                startActivity(detailIntent);
            }
        });
    }

    private class LoadDepartments extends AsyncTask<Void, Void, Void> {

        private Activity activity;
        private String serverResponse;

        protected LoadDepartments(Activity activity) {
            this.activity = activity;
        }

        protected Void doInBackground(Void... arg0) {
            String url = "http://" + hostAddress + "/project1/getDepartments";
            HttpHandler handler = new HttpHandler();
            serverResponse = handler.makeServiceCall(url);
            return null;
        }

        protected void onPostExecute(Void result) {
            if (serverResponse != null) {
                try {
                    JSONObject jsonObj = new JSONObject(serverResponse);
                    JSONArray departments = jsonObj.getJSONArray("departments");

                    ArrayList<String> deptNames = new ArrayList<>();
                    deptNames.add("All Departments");

                    for (int i = 0; i < departments.length(); i++) {
                        JSONObject dept = departments.getJSONObject(i);
                        jsonDepartment jDept = new jsonDepartment(dept);
                        departmentList.add(jDept);
                        deptNames.add(jDept.getDeptName());
                    }

                    ArrayAdapter<String> deptAdapter = new ArrayAdapter<>(activity, android.R.layout.simple_spinner_item, deptNames);
                    deptAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
                    departmentSpinner.setAdapter(deptAdapter);

                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private class LoadProducts extends AsyncTask<Void, Void, Void> {

        private Activity activity;
        private String serverResponse;

        protected LoadProducts(Activity activity) {
            this.activity = activity;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            Toast.makeText(ProductListActivity.this, "Loading products...", Toast.LENGTH_SHORT).show();
        }

        protected Void doInBackground(Void... arg0) {
            String url = "http://" + hostAddress + "/project1/getProducts";
            HttpHandler handler = new HttpHandler();
            serverResponse = handler.makeServiceCall(url);
            return null;
        }

        protected void onPostExecute(Void result) {
            updateProductList(serverResponse);
        }
    }

    private class SearchProducts extends AsyncTask<Void, Void, Void> {

        private Activity activity;
        private String serverResponse;
        private String searchTerm;
        private int deptId;

        protected SearchProducts(Activity activity, String searchTerm, int deptId) {
            this.activity = activity;
            this.searchTerm = searchTerm;
            this.deptId = deptId;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            Toast.makeText(ProductListActivity.this, "Searching...", Toast.LENGTH_SHORT).show();
        }

        protected Void doInBackground(Void... arg0) {
            String url = "http://" + hostAddress + "/project1/searchProducts?searchTerm=" + searchTerm + "&deptId=" + deptId;
            HttpHandler handler = new HttpHandler();
            serverResponse = handler.makeServiceCall(url);
            return null;
        }

        protected void onPostExecute(Void result) {
            updateProductList(serverResponse);
        }
    }

    private void updateProductList(String serverResponse) {
        productList.clear();

        if (serverResponse != null) {
            try {
                JSONObject jsonObj = new JSONObject(serverResponse);
                JSONArray products = jsonObj.getJSONArray("products");

                for (int i = 0; i < products.length(); i++) {
                    JSONObject prod = products.getJSONObject(i);
                    jsonProduct jProd = new jsonProduct(prod);
                    productList.add(jProd);
                }

                productAdapter = new ProductAdapter(this, productList, hostAddress);
                productListView.setAdapter(productAdapter);

                Toast.makeText(this, "Found " + productList.size() + " products", Toast.LENGTH_SHORT).show();

            } catch (Exception e) {
                e.printStackTrace();
                Toast.makeText(this, "Error loading products", Toast.LENGTH_SHORT).show();
            }
        }
    }
}
