package com.example.vejecelle_projekt;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.fragment.app.FragmentManager;

import android.Manifest;
import android.annotation.SuppressLint;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;


public class MainActivity extends AppCompatActivity {


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        //Bluetooth del
        BluetoothManager bluetoothManager = getSystemService(BluetoothManager.class);
        BluetoothAdapter btAdapter = bluetoothManager.getAdapter();


        if (getPackageManager().hasSystemFeature(PackageManager.FEATURE_BLUETOOTH) != true) {
            Toast.makeText(this, "Du har ikke Bluetooth MAKKER!", Toast.LENGTH_SHORT).show();
        }
        if (ContextCompat.checkSelfPermission(this,
                Manifest.permission.BLUETOOTH_ADMIN) ==
                PackageManager.PERMISSION_GRANTED) {
            BluetoothDevice hc05 = btAdapter.getRemoteDevice("98:D3:C1:FD:DF:9B");
            System.out.println(hc05.getName());
        }


        //Fragmentmanager defineres
        FragmentManager fragmentManager = getSupportFragmentManager();

        //Håndtering af hjem knap
        Button btnhjem = findViewById(R.id.btnHome);
        btnhjem.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                fragmentManager.beginTransaction()
                        .replace(R.id.fragmentContainerView, HjemFragment.class, null)
                        .setReorderingAllowed(true)
                        .addToBackStack("name") // name can be null
                        .commit();
            }
        });
        //Håndtering af måling knap
        Button btnmaaling = findViewById(R.id.btnMaaling);
        btnmaaling.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                FragmentManager fragmentManager = getSupportFragmentManager();
                fragmentManager.beginTransaction()
                        .replace(R.id.fragmentContainerView, MaalingFragment.class, null)
                        .setReorderingAllowed(true)
                        .addToBackStack("name") // name can be null
                        .commit();
            }
        });
        //Håndtering af notifikations knap
        Button btnnotifikation = findViewById(R.id.btnNotifications);
        btnnotifikation.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                fragmentManager.beginTransaction()
                        .replace(R.id.fragmentContainerView, NotifikationerFragment.class, null)
                        .setReorderingAllowed(true)
                        .addToBackStack("name") // name can be null
                        .commit();
            }
        });
    }
}