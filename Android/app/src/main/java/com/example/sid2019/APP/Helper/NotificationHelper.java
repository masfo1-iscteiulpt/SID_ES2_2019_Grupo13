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
    private static final String CHANNEL_ID = "default";
    private Context context;
    private NotificationManager notificationManager;


    public NotificationHelper(Context mainActivity) {
        this.context=mainActivity;
        createNotificationChannel();

    }

    public void createNotification(){
        int notificationId = 1001;
        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, CHANNEL_ID);
        builder.setSmallIcon(R.mipmap.ic_launcher);
        builder.setContentTitle("notification");
        builder.setContentText("conteudo");
        Notification notification = builder.build();
        notificationManager.notify(notificationId, notification);

    }

    private void createNotificationChannel() {
        // Create the NotificationChannel, but only on API 26+ because
        // the NotificationChannel class is new and not in the support library
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            CharSequence name = "notifications";
            String description = "notifies";
            int importance = NotificationManager.IMPORTANCE_DEFAULT;
            NotificationChannel channel = new NotificationChannel(CHANNEL_ID, name, importance);
            channel.setDescription(description);
            // Register the channel with the system; you can't change the importance
            // or other notification behaviors after this
            notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
            notificationManager.createNotificationChannel(channel);
        }
        else{
            throw new UnsupportedOperationException();
        }
    }
}
