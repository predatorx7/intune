/*
 * Copyright 2023, Mushaheed Syed. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

package com.hdfc.flutter_plugins.intune_android


import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.microsoft.identity.client.Logger
import com.microsoft.identity.client.internal.configuration.LogLevelDeserializer
import com.microsoft.identity.common.internal.authorities.AzureActiveDirectoryAudienceDeserializer
import com.microsoft.identity.common.java.authorities.Authority
import com.microsoft.identity.common.java.authorities.AuthorityDeserializer
import com.microsoft.identity.common.java.authorities.AzureActiveDirectoryAudience
import java.io.File

class MSALConfigParser {
    companion object {
        fun  parse(map: Map<String, Any?>): File{

            val gson: Gson = getGsonForLoadingConfiguration()

            val file = File.createTempFile("config", "json", null)

            // create a new file
            file.writeText(gson.toJson(map))

            return file
        }

        private fun getGsonForLoadingConfiguration(): Gson {
            return GsonBuilder()
                    .registerTypeAdapter(
                            Authority::class.java,
                            AuthorityDeserializer()
                    )
                    .registerTypeAdapter(
                            AzureActiveDirectoryAudience::class.java,
                            AzureActiveDirectoryAudienceDeserializer()
                    )
                    .registerTypeAdapter(
                            Logger.LogLevel::class.java,
                            LogLevelDeserializer()
                    )
                    .create()
        }
    }
}