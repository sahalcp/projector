package com.projectorllc.projectorapp;

import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.res.Configuration;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;


import com.github.rubensousa.previewseekbar.PreviewBar;
import com.github.rubensousa.previewseekbar.exoplayer.PreviewTimeBar;
import com.projectorllc.projectorapp.exoplayer.ExoPlayerManager;
import com.projectorllc.projectorapp.webService.Const;
import com.projectorllc.projectorapp.webService.PlayerModel;
import com.projectorllc.projectorapp.webService.WebHandler;
import com.google.android.exoplayer2.ui.PlayerView;

import org.jetbrains.annotations.NotNull;

import io.flutter.embedding.android.FlutterActivity;
import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class PlayerActivity extends FlutterActivity {
    private ExoPlayerManager exoPlayerManager;
    PreviewTimeBar previewTimeBar;
    String videoUrl, thumbnailPreview, videoTitle,token,videoId,baseUrl;
    int spriteRow, spriteColumn;
    TextView  currentTime;
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_player);
        getIntentData();
        PlayerView playerView = findViewById(R.id.player_view);
        previewTimeBar = playerView.findViewById(R.id.exo_progress);
        currentTime = playerView.findViewById(R.id.exo_position);

        ImageView imgFullscreen = findViewById(R.id.img_fullscreen);
        TextView imgClose = findViewById(R.id.img_close);

        try {
            TextView title = findViewById(R.id.txt_title);
            title.setText(videoTitle != null ? videoTitle : "");
        } catch (Exception e) {
            e.printStackTrace();
        }
        imgFullscreen.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int orientation = getResources().getConfiguration().orientation;
                if (orientation == Configuration.ORIENTATION_PORTRAIT) {
                    // In landscape
                    setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
                } else {
                    // In portrait
                    setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
                }

            }
        });

        imgClose.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                pausedApi();
                finish();
            }
        });


        previewTimeBar.addOnPreviewVisibilityListener((previewBar, isPreviewShowing) -> {
            Log.d("PreviewShowing", String.valueOf(isPreviewShowing));
        });

        previewTimeBar.addOnScrubListener(new PreviewBar.OnScrubListener() {
            @Override
            public void onScrubStart(PreviewBar previewBar) {
                Log.d("Scrub--->", "START");
            }

            @Override
            public void onScrubMove(PreviewBar previewBar, int progress, boolean fromUser) {
                Log.d("Scrub--->", "MOVE to " + progress / 1000 + " FROM USER: " + fromUser);
            }

            @Override
            public void onScrubStop(PreviewBar previewBar) {
                Log.d("Scrub--->", "STOP");
               // Log.d("Scrub value--->", currentTime.getText().toString());

                // Api Call
                pausedApi();
            }
        });

        exoPlayerManager = new ExoPlayerManager(playerView, previewTimeBar,
                findViewById(R.id.imageView), thumbnailPreview, spriteRow, spriteColumn);

        exoPlayerManager.play(Uri.parse(videoUrl));

//        if (exoPlayerManager.isPlaying()){
//            Log.d("Scrub play--->", "PLAY");
//        }else{
//            Log.d("Scrub pause--->", "PAUSE");
//        }

        // requestFullScreenIfLandscape();
        // setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
    }

    private void getIntentData() {
        Intent intent = getIntent();
        baseUrl = intent.getStringExtra("BASE_URL");
        Const.Companion.setBASE_URL(baseUrl != null ? baseUrl+"/" : Const.Companion.getBASE_URL_ACTUAL());

        thumbnailPreview = intent.getStringExtra("THUMBNAIL_PREVIEW");
        videoUrl = intent.getStringExtra("VIDEO_URL");
        videoTitle = intent.getStringExtra("VIDEO_TITLE");
        spriteRow = intent.getIntExtra("SPRITE_ROW", 0);
        spriteColumn = intent.getIntExtra("SPRITE_COLUMN", 0);
        videoId = intent.getStringExtra("VIDEO_ID");
        token = intent.getStringExtra("TOKEN");
        Log.e("video url intent --->", videoId + "," + token
                + "," + baseUrl + "," + spriteRow + "," + spriteColumn+","+thumbnailPreview);



    }

    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
        super.onWindowFocusChanged(hasFocus);
        if (hasFocus) {
            //requestFullScreenIfLandscape();
        }
    }

    @Override
    public void onStart() {
        super.onStart();
        exoPlayerManager.onStart();

    }

    @Override
    public void onResume() {
        super.onResume();
        exoPlayerManager.onResume();
    }

    @Override
    public void onPause() {
        super.onPause();
        exoPlayerManager.onPause();
    }

    @Override
    public void onStop() {
        super.onStop();
        exoPlayerManager.onStop();
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
    }

    private void pausedApi(){
        WebHandler handler = new WebHandler();
        PlayerModel model = new PlayerModel(token,videoId,currentTime.getText().toString());
        handler.updatePlayerSeek(model).enqueue(new Callback<ResponseBody>() {
            @Override
            public void onResponse(@NotNull Call<ResponseBody> call, @NotNull Response<ResponseBody> response) {
                try {
                    Log.e("API RESULT", String.valueOf(response.body()));
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                try {
                    Log.e("API RESULT FAIL", t.toString());
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }
    private void requestFullScreenIfLandscape() {
        getWindow().getDecorView().setSystemUiVisibility(
                View.SYSTEM_UI_FLAG_IMMERSIVE
                        | View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                        | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                        | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                        // Hide the nav bar and status bar
                        | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                        | View.SYSTEM_UI_FLAG_FULLSCREEN);
    }
}
