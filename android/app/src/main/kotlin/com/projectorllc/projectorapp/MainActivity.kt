package com.projectorllc.projectorapp

import android.content.Context
import android.content.Intent
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Base64
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException

class MainActivity: FlutterActivity() {



    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        printHashKey(this@MainActivity)
    }
    fun printHashKey(pContext: Context) {
        try {
            val info: PackageInfo = pContext.getPackageManager().getPackageInfo(pContext.getPackageName(), PackageManager.GET_SIGNATURES)
            for (signature in info.signatures) {
                val md = MessageDigest.getInstance("SHA")
                md.update(signature.toByteArray())
                val hashKey = String(Base64.encode(md.digest(), 0))
                Log.e("MainActivity", "printHashKey() Hash Key: $hashKey")
            }
        } catch (e: NoSuchAlgorithmException) {
            Log.e("MainActivity", "printHashKey()", e)
        } catch (e: Exception) {
            Log.e("MainActivity", "printHashKey()", e)
        }
    }



   /* private val CHANNEL = "flutter.native/helper"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            // Note: this method is invoked on the main thread.
            // TODO
            if (call.method.equals("flutterToNative")){


                val thumbnailPreview = call.argument<String>("thumbnailPreview")
                val videoFile = call.argument<String>("videoUrl")
                val videoTitle = call.argument<String>("videoTitle")
                val spriteRow = call.argument<Int>("spriteRow")
                val spriteColumn = call.argument<Int>("spriteColumn")
                val videoId = call.argument<String>("videoId")
                val token = call.argument<String>("token")
                val baseUrl = call.argument<String>("baseUrl")
                //Log.e("SOORYA","valllll4 --->$videoTitle")


                if (videoFile !=null){

                    val intent= Intent(this,PlayerActivity::class.java)
                    intent.putExtra("THUMBNAIL_PREVIEW",thumbnailPreview)
                    intent.putExtra("VIDEO_URL",videoFile)
                    intent.putExtra("VIDEO_TITLE",videoTitle)
                    intent.putExtra("SPRITE_ROW",spriteRow)
                    intent.putExtra("SPRITE_COLUMN",spriteColumn)
                    intent.putExtra("VIDEO_ID",videoId)
                    intent.putExtra("TOKEN",token)
                    intent.putExtra("BASE_URL",baseUrl)
                    startActivity(intent)
                }else{
                    result.error("Error Native","error native values",null)
                }

               // result.success("flutter buttons")
            }else{
                result.notImplemented()
            }
        }
    }*/
}