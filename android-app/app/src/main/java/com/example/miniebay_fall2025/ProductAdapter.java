package com.example.miniebay_fall2025;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.io.InputStream;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;

public class ProductAdapter extends ArrayAdapter<jsonProduct> {

    private Context context;
    private ArrayList<jsonProduct> products;
    private String hostAddress;
    private HashMap<String, Bitmap> imageCache;

    public ProductAdapter(Context context, ArrayList<jsonProduct> products, String hostAddress) {
        super(context, R.layout.product_list_item, products);
        this.context = context;
        this.products = products;
        this.hostAddress = hostAddress;
        this.imageCache = new HashMap<>();
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        ViewHolder holder;

        if (convertView == null) {
            LayoutInflater inflater = LayoutInflater.from(context);
            convertView = inflater.inflate(R.layout.product_list_item, parent, false);

            holder = new ViewHolder();
            holder.imageProductThumb = convertView.findViewById(R.id.imageProductThumb);
            holder.textProductName = convertView.findViewById(R.id.textProductName);
            holder.textProductDept = convertView.findViewById(R.id.textProductDept);
            holder.textProductBid = convertView.findViewById(R.id.textProductBid);

            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }

        jsonProduct product = products.get(position);

        holder.textProductName.setText(product.getProductName());
        holder.textProductDept.setText(product.getDeptName());
        holder.textProductBid.setText("$" + String.format("%.2f", product.getCurrentBid()));

        String imagePath = product.getImagePath();
        if (imagePath != null && !imagePath.isEmpty()) {
            String imageUrl = "http://" + hostAddress + "/project1/" + imagePath;

            if (imageCache.containsKey(imageUrl)) {
                holder.imageProductThumb.setImageBitmap(imageCache.get(imageUrl));
            } else {
                holder.imageProductThumb.setImageResource(android.R.drawable.ic_menu_gallery);
                new LoadImageTask(holder.imageProductThumb, imageUrl).execute();
            }
        } else {
            holder.imageProductThumb.setImageResource(android.R.drawable.ic_menu_gallery);
        }

        return convertView;
    }

    private static class ViewHolder {
        ImageView imageProductThumb;
        TextView textProductName;
        TextView textProductDept;
        TextView textProductBid;
    }

    private class LoadImageTask extends AsyncTask<Void, Void, Bitmap> {

        private ImageView imageView;
        private String imageUrl;

        public LoadImageTask(ImageView imageView, String imageUrl) {
            this.imageView = imageView;
            this.imageUrl = imageUrl;
        }

        @Override
        protected Bitmap doInBackground(Void... params) {
            Bitmap bitmap = null;
            try {
                InputStream in = new URL(imageUrl).openStream();
                bitmap = BitmapFactory.decodeStream(in);
                if (bitmap != null) {
                    imageCache.put(imageUrl, bitmap);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            return bitmap;
        }

        @Override
        protected void onPostExecute(Bitmap result) {
            if (result != null) {
                imageView.setImageBitmap(result);
            }
        }
    }
}
