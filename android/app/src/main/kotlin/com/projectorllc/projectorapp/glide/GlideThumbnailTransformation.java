package com.projectorllc.projectorapp.glide;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import androidx.annotation.NonNull;

import com.bumptech.glide.load.engine.bitmap_recycle.BitmapPool;
import com.bumptech.glide.load.resource.bitmap.BitmapTransformation;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.security.MessageDigest;


public class GlideThumbnailTransformation extends BitmapTransformation {

    private static  int MAX_ROWS = 0;
    private static  int MAX_COLUMNS = 0;
    private static final int THUMBNAILS_EACH = 5000; // milliseconds

    private int x;
    private int y;

    public GlideThumbnailTransformation(long position, int maxRow,int maxColumn) {
        int square = (int) position / THUMBNAILS_EACH;
        MAX_ROWS = maxRow;
        MAX_COLUMNS = maxColumn;
        y = square / MAX_ROWS;
        x = square % MAX_COLUMNS;
    }

    private int getX() {
        return x;
    }

    private int getY() {
        return y;
    }

    @Override
    protected Bitmap transform(@NonNull BitmapPool pool, @NonNull Bitmap toTransform,
                               int outWidth, int outHeight) {
        int width = toTransform.getWidth() / MAX_COLUMNS;
        int height = toTransform.getHeight() / MAX_ROWS;
        //Log.e("SOORYA --->",""+width+","+height+","+x+","+y);
        Bitmap bitmap = Bitmap.createBitmap(toTransform, x * width, y * height, width, height);

        Bitmap decoded = null;
        try {
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            bitmap.compress(Bitmap.CompressFormat.PNG, 40, out);
            decoded = BitmapFactory.decodeStream(new ByteArrayInputStream(out.toByteArray()));
        } catch (Exception e) {
            e.printStackTrace();
             width = toTransform.getWidth() / MAX_COLUMNS;
             height = toTransform.getHeight() / MAX_ROWS;
             bitmap = Bitmap.createBitmap(toTransform, x * width, y * height, width, height);
             return bitmap;
        }

        return decoded;
    }

    @Override
    public void updateDiskCacheKey(MessageDigest messageDigest) {
        byte[] data = ByteBuffer.allocate(8).putInt(x).putInt(y).array();
        messageDigest.update(data);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        GlideThumbnailTransformation that = (GlideThumbnailTransformation) o;

        if (x != that.x) return false;
        return y == that.y;
    }

    @Override
    public int hashCode() {
        int result = x;
        result = 31 * result + y;
        return result;
    }
}
