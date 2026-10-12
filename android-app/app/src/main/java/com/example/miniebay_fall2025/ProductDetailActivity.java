package com.example.miniebay_fall2025;

import androidx.appcompat.app.AppCompatActivity;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.InputStream;
import java.net.URL;

public class ProductDetailActivity extends AppCompatActivity {

    public Activity activity;
    protected String hostAddress = "10.0.2.2:8080";
    private jsonPerson currentUser;
    private int productId;
    private double currentBid;

    private TextView textProductName;
    private TextView textDescription;
    private TextView textCurrentBid;
    private TextView textStartingBid;
    private TextView textDueDate;
    private TextView textDepartment;
    private TextView textSeller;
    private TextView textBidHistory;
    private ImageView imageProduct;
    private EditText editBidAmount;
    private Button buttonPlaceBid;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_product_detail);

        activity = this;

        Intent i = getIntent();
        productId = i.getIntExtra("productId", 0);
        currentUser = (jsonPerson) i.getSerializableExtra("jPerson");

        textProductName = findViewById(R.id.textProductName);
        textDescription = findViewById(R.id.textDescription);
        textCurrentBid = findViewById(R.id.textCurrentBid);
        textStartingBid = findViewById(R.id.textStartingBid);
        textDueDate = findViewById(R.id.textDueDate);
        textDepartment = findViewById(R.id.textDepartment);
        textSeller = findViewById(R.id.textSeller);
        textBidHistory = findViewById(R.id.textBidHistory);
        imageProduct = findViewById(R.id.imageProduct);
        editBidAmount = findViewById(R.id.editBidAmount);
        buttonPlaceBid = findViewById(R.id.buttonPlaceBid);

        new LoadProductDetail(activity).execute();

        buttonPlaceBid.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String bidAmountStr = editBidAmount.getText().toString();
                if (bidAmountStr.isEmpty()) {
                    Toast.makeText(ProductDetailActivity.this, "Please enter a bid amount", Toast.LENGTH_SHORT).show();
                    return;
                }
                new PlaceBid(activity, bidAmountStr).execute();
            }
        });
    }

    private class LoadProductDetail extends AsyncTask<Void, Void, Void> {

        private Activity activity;
        private String serverResponse;

        protected LoadProductDetail(Activity activity) {
            this.activity = activity;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            Toast.makeText(ProductDetailActivity.this, "Loading product details...", Toast.LENGTH_SHORT).show();
        }

        protected Void doInBackground(Void... arg0) {
            String url = "http://" + hostAddress + "/project1/getProductDetail?productId=" + productId;
            HttpHandler handler = new HttpHandler();
            serverResponse = handler.makeServiceCall(url);
            return null;
        }

        protected void onPostExecute(Void result) {
            if (serverResponse != null) {
                try {
                    JSONObject jsonObj = new JSONObject(serverResponse);
                    String status = jsonObj.getString("status");

                    if (status.equals("success")) {
                        JSONObject product = jsonObj.getJSONObject("product");

                        String productName = product.getString("productName");
                        String description = product.getString("description");
                        currentBid = product.getDouble("currentBid");
                        double startingBid = product.getDouble("startingBid");
                        String dueDate = product.getString("dueDate");
                        String deptName = product.getString("deptName");
                        String sellerUserName = product.getString("sellerUserName");
                        String imagePath = product.optString("imagePath", "");
                        int bidCount = product.getInt("bidCount");

                        textProductName.setText(productName);
                        textDescription.setText("Description: " + description);
                        textCurrentBid.setText("Current Bid: $" + String.format("%.2f", currentBid));
                        textStartingBid.setText("Starting Bid: $" + String.format("%.2f", startingBid));
                        textDueDate.setText("Due Date: " + dueDate);
                        textDepartment.setText("Department: " + deptName);
                        textSeller.setText("Seller: " + sellerUserName);

                        JSONArray bids = product.getJSONArray("bids");
                        StringBuilder bidHistoryBuilder = new StringBuilder();
                        bidHistoryBuilder.append("Bid History (" + bidCount + " bids):\n");

                        for (int i = 0; i < bids.length(); i++) {
                            JSONObject bid = bids.getJSONObject(i);
                            String bidderName = bid.getString("bidderName");
                            double bidAmount = bid.getDouble("bidAmount");
                            String bidDate = bid.getString("bidDate");
                            bidHistoryBuilder.append("- " + bidderName + ": $" + String.format("%.2f", bidAmount) + " (" + bidDate + ")\n");
                        }

                        if (bidCount == 0) {
                            bidHistoryBuilder.append("No bids yet. Be the first to bid!");
                        }

                        textBidHistory.setText(bidHistoryBuilder.toString());

                        if (imagePath != null && !imagePath.isEmpty()) {
                            new LoadImage(imageProduct, "http://" + hostAddress + "/project1/" + imagePath).execute();
                        }

                    } else {
                        Toast.makeText(ProductDetailActivity.this, "Product not found", Toast.LENGTH_SHORT).show();
                    }

                } catch (Exception e) {
                    e.printStackTrace();
                    Toast.makeText(ProductDetailActivity.this, "Error loading product", Toast.LENGTH_SHORT).show();
                }
            }
        }
    }

    private class LoadImage extends AsyncTask<Void, Void, Bitmap> {

        private ImageView imageView;
        private String imageUrl;

        protected LoadImage(ImageView imageView, String imageUrl) {
            this.imageView = imageView;
            this.imageUrl = imageUrl;
        }

        protected Bitmap doInBackground(Void... arg0) {
            Bitmap bitmap = null;
            try {
                InputStream in = new URL(imageUrl).openStream();
                bitmap = BitmapFactory.decodeStream(in);
            } catch (Exception e) {
                e.printStackTrace();
            }
            return bitmap;
        }

        protected void onPostExecute(Bitmap result) {
            if (result != null) {
                imageView.setImageBitmap(result);
            }
        }
    }

    private class PlaceBid extends AsyncTask<Void, Void, Void> {

        private Activity activity;
        private String serverResponse;
        private String bidAmount;

        protected PlaceBid(Activity activity, String bidAmount) {
            this.activity = activity;
            this.bidAmount = bidAmount;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            Toast.makeText(ProductDetailActivity.this, "Placing bid...", Toast.LENGTH_SHORT).show();
        }

        protected Void doInBackground(Void... arg0) {
            String url = "http://" + hostAddress + "/project1/placeBid";
            HttpHandler handler = new HttpHandler();
            serverResponse = handler.makeServiceCallPostBid(url, String.valueOf(productId), currentUser.getUserName(), bidAmount);
            return null;
        }

        protected void onPostExecute(Void result) {
            if (serverResponse != null) {
                try {
                    JSONObject jsonObj = new JSONObject(serverResponse);
                    String status = jsonObj.getString("status");
                    String message = jsonObj.getString("message");

                    Toast.makeText(ProductDetailActivity.this, message, Toast.LENGTH_LONG).show();

                    if (status.equals("success")) {
                        new LoadProductDetail(activity).execute();
                        editBidAmount.setText("");
                    }

                } catch (Exception e) {
                    e.printStackTrace();
                    Toast.makeText(ProductDetailActivity.this, "Error placing bid", Toast.LENGTH_SHORT).show();
                }
            }
        }
    }
}
