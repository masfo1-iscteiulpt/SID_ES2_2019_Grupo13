package com.example.sid2019.APP.Helper;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.os.Build;
import android.support.v4.app.NotificationCompat;
import android.app.Notification;

import com.example.sid2019.APP.MainActivity;
import com.example.sid2019.R;

import static android.provider.Settings.System.getString;
import static android.support.v4.content.ContextCompat.getSystemService;

public class NotificationHelper {
    private static NotificationHelper instance;
    private static final String CHANNEL_ID = "alertas";
    private Context context;
    private NotificationManager notificationManager;
    private int notificationId;

    public static NotificationHelper getInstance(Context context){
        if (instance==null){
            instance= new NotificationHelper(context);
        }
        instance.context=context;
        return instance;
    }

    public NotificationHelper(Context mainActivity) {
        this.context=mainActivity;
        createNotificationChannel();
        notificationId=0;
        instance=this;
    }

    public void createNotification(String title,String text){
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationCompat.Builder builder = new NotificationCompat.Builder(context, CHANNEL_ID);
            builder.setSmallIcon(R.mipmap.ic_launcher);
            builder.setContentTitle(title);
            builder.setContentText(text);
            Notification notification = builder.build();
            notificationManager.notify(notificationId, notification);
            notificationId++;
        }
    }

    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            CharSequence name = "notifications";
            String description = "notifies";
            int importance = NotificationManager.IMPORTANCE_DEFAULT;
            NotificationChannel channel = new NotificationChannel(CHANNEL_ID, name, importance);
            channel.setDescription(description);
            notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
            notificationManager.createNotificationChannel(channel);
        }
    }
}
