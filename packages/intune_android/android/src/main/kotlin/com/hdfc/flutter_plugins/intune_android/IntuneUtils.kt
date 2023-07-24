package com.hdfc.flutter_plugins.intune_android

import com.microsoft.identity.client.AcquireTokenSilentParameters
import com.microsoft.identity.client.IAccount
import com.microsoft.identity.client.IAuthenticationResult
import com.microsoft.identity.client.IMultipleAccountPublicClientApplication
import com.microsoft.identity.client.IPublicClientApplication
import com.microsoft.identity.client.ISingleAccountPublicClientApplication
import com.microsoft.identity.client.SilentAuthenticationCallback
import com.microsoft.identity.client.exception.MsalException
import java.util.logging.Level
import java.util.logging.Logger

class IntuneUtils(private val app: IPublicClientApplication, private val reply: IntuneReply) {
    companion object {
        private val LOGGER = Logger.getLogger(IntuneUtils::class.java.name)
    }

    private fun getAccount(aadId: String): IAccount? {
        if (app is IMultipleAccountPublicClientApplication) {
            return app.getAccount(aadId)
        } else if (app is ISingleAccountPublicClientApplication) {
            val accountResult = app.currentAccount
            if (accountResult != null) {
                val account = accountResult.currentAccount
                // make sure this is the correct user
                if (account != null && account.id != aadId) {
                    return null
                }
                return account
            }
        }
        return null
    }

    fun acquireTokenSilent(
            upn: String,
            aadId: String,
            scopes: List<String>,
    ): String? {
        try {
            val account = getAccount(aadId) ?: return null
            val params = AcquireTokenSilentParameters.Builder()
                    .forAccount(account)
                    .fromAuthority(account.authority)
                    .withScopes(scopes)
                    .withCallback(object : SilentAuthenticationCallback {
                        override fun onSuccess(authenticationResult: IAuthenticationResult?) {
                            if (authenticationResult != null) {
                                reply.onMSALAuthenticationResult(authenticationResult)
                            } else {
                                reply.onErrorType(MSALErrorType.UNKNOWN)
                            }
                        }

                        override fun onError(exception: MsalException?) {
                            reply.onMsalException(exception)
                        }
                    }
                    )
                    .build()
            val result = app.acquireTokenSilent(params)

            return result.accessToken
        } catch (e: Throwable) {
            LOGGER.log(Level.SEVERE, "Failed to get token silently", e)
        }
        return null
    }

}