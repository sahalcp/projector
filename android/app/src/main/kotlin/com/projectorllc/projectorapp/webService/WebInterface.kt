package com.projectorllc.projectorapp.webService

import okhttp3.ResponseBody
import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.POST

interface WebInterface {
    @POST("updateVideoPaused")
    fun updatePlayerSeek(@Body request: PlayerModel): Call<ResponseBody>


}