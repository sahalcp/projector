package com.projectorllc.projectorapp.webService

import okhttp3.OkHttpClient
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.util.concurrent.TimeUnit

abstract class BaseRepository {
    var retrofitInstance: Retrofit? = null
    protected abstract val serviceUrl: String
    protected abstract fun initialiseApi()

    private fun initialiseRetrofitBuilder() {
        val client = OkHttpClient.Builder()
            .readTimeout(30, TimeUnit.MINUTES)
            .connectTimeout(30, TimeUnit.MINUTES)
            .build()

        retrofitInstance = Retrofit.Builder()
            .baseUrl(serviceUrl)
            .addConverterFactory(GsonConverterFactory.create())
            .client(client)
            .build()
        initialiseApi()

    }

    init {
        initialiseRetrofitBuilder()
    }

}