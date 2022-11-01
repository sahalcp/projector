package com.projectorllc.projectorapp.exoplayer;

import android.net.Uri;
import android.widget.ImageView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.request.target.Target;
import com.github.rubensousa.previewseekbar.PreviewBar;
import com.github.rubensousa.previewseekbar.PreviewLoader;
import com.github.rubensousa.previewseekbar.exoplayer.PreviewTimeBar;
import com.projectorllc.projectorapp.glide.GlideThumbnailTransformation;
import com.google.android.exoplayer2.Player;
import com.google.android.exoplayer2.SimpleExoPlayer;
import com.google.android.exoplayer2.ui.PlayerView;
import com.google.android.exoplayer2.util.Util;

public class ExoPlayerManager implements PreviewLoader, PreviewBar.OnScrubListener {

    private ExoPlayerMediaSourceBuilder mediaSourceBuilder;
    private PlayerView playerView;
    private SimpleExoPlayer player;
    private PreviewTimeBar previewTimeBar;
    private String thumbnailsUrl;
    private ImageView imageView;
    private int maxRow;
    private int maxColumn;
    private boolean resumeVideoOnPreviewStop;
//    private Player.EventListener eventListener = new Player.EventListener() {
//        @Override
//        public void onPlayerStateChanged(boolean playWhenReady, int playbackState) {
//            if (playbackState == Player.STATE_READY && playWhenReady) {
//                previewTimeBar.hidePreview();
//            }
//        }
//    };

    public ExoPlayerManager(PlayerView playerView,
                            PreviewTimeBar previewTimeBar, ImageView imageView,
                            String thumbnailsUrl,int maxRow, int maxColumn) {
        this.playerView = playerView;
        this.imageView = imageView;
        this.previewTimeBar = previewTimeBar;
        this.mediaSourceBuilder = new ExoPlayerMediaSourceBuilder(playerView.getContext());
        this.thumbnailsUrl = thumbnailsUrl;
        this.previewTimeBar.addOnScrubListener(this);
        this.previewTimeBar.setPreviewLoader(this);
        this.resumeVideoOnPreviewStop = true;
        this.maxRow = maxRow;
        this.maxColumn = maxColumn;
    }

    public void play(Uri uri) {
        mediaSourceBuilder.setUri(uri);
    }

    public void onStart() {
        if (Util.SDK_INT > 23) {
            createPlayers();
        }
    }

    public void onResume() {
        if (Util.SDK_INT <= 23) {
            createPlayers();
        }
    }

    public void onPause() {
        if (Util.SDK_INT <= 23) {
            releasePlayers();
        }
    }

    public void onStop() {
        if (Util.SDK_INT > 23) {
            releasePlayers();
        }
    }

    public void setResumeVideoOnPreviewStop(boolean resume) {
        this.resumeVideoOnPreviewStop = resume;
    }

    private void releasePlayers() {
        if (player != null) {
            player.release();
            player = null;
        }
    }

    private void createPlayers() {
        if (player != null) {
            player.release();
        }
        player = createPlayer();
        playerView.setPlayer(player);
        playerView.setControllerShowTimeoutMs(15000);
    }

    private SimpleExoPlayer createPlayer() {
        SimpleExoPlayer player = new SimpleExoPlayer.Builder(playerView.getContext()).build();
        player.setPlayWhenReady(true);
        player.prepare(mediaSourceBuilder.getMediaSource(false));
       // player.addListener(eventListener);
        return player;
    }

    @Override
    public void loadPreview(long currentPosition, long max) {
        if (player.isPlaying()) {
            player.setPlayWhenReady(false);
        }
        Glide.with(imageView)
                .load(thumbnailsUrl)
                .override(Target.SIZE_ORIGINAL, Target.SIZE_ORIGINAL)
                .transform(new GlideThumbnailTransformation(currentPosition,maxRow,maxColumn))
                .into(imageView);
    }

    @Override
    public void onScrubStart(PreviewBar previewBar) {
        player.setPlayWhenReady(false);
    }

    @Override
    public void onScrubMove(PreviewBar previewBar, int progress, boolean fromUser) {

    }

    @Override
    public void onScrubStop(PreviewBar previewBar) {
        if (resumeVideoOnPreviewStop) {
            player.setPlayWhenReady(true);
        }
    }

}