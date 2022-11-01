package com.projectorllc.projectorapp.webService

import okhttp3.ResponseBody
import retrofit2.Call

class WebHandler : BaseRepository() {
    private var webInterface: WebInterface? = null
    override val serviceUrl: String
        get() = Const.BASE_URL

    override fun initialiseApi() {
        webInterface = retrofitInstance?.create(WebInterface::class.java)
    }

    fun updatePlayerSeek(model: PlayerModel): Call<ResponseBody>? {
        return webInterface?.updatePlayerSeek(model)
    }

}