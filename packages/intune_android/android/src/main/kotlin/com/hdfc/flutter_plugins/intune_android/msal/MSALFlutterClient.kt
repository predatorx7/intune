package com.hdfc.flutter_plugins.intune_android.msal

import android.app.Activity
import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.microsoft.identity.client.Account
import com.microsoft.identity.client.AuthenticationCallback
import com.microsoft.identity.client.AuthenticationResult
import com.microsoft.identity.client.IAccount
import com.microsoft.identity.client.IAuthenticationResult
import com.microsoft.identity.client.IPublicClientApplication
import com.microsoft.identity.client.MultipleAccountPublicClientApplication
import com.microsoft.identity.client.SingleAccountPublicClientApplication
import com.microsoft.identity.client.exception.MsalClientException
import com.microsoft.identity.client.exception.MsalException
import io.flutter.plugin.common.MethodChannel

class MSALFlutterClient {
    companion object {
        const val TAG = "MSALFlutterClient"
    }
    private lateinit var activity: Activity
    private lateinit var context: Context
    private lateinit var msalApp: IPublicClientApplication
    private fun isClientInitialized() = ::msalApp.isInitialized

    // initializes the PCA
    private fun initialize(args: HashMap<String, Any>?): String? {
        if (args == null) {
            Log.d(TAG, "error no clientId")
            result.error("NO_CONFIG", "Call must include a config", null)
            return "NO_CONFIG"
        }
        // Key-values that match PublicClientApplicationConfiguration's properties
        val configFile = MSALConfigParser.parse(args)
        try {
            MultipleAccountPublicClientApplication.create(
                    context, configFile, getApplicationCreatedListener(result)
            )
            return null
        } catch (e: Throwable) {
            Log.e(TAG, "Failed to initialize", e);
            return "UNKNOWN_ERROR"
        }
    }


    private fun acquireToken(args: HashMap<String, Any>?, result: MethodChannel.Result) {

        if (args == null) {
            Log.d(TAG, "error no clientId")
            result.error("NO_CONFIG", "Call must include a config", null)
            return
        }
        // check if client has been initialized
        if (!isClientInitialized()) {
            Log.d(TAG, "Client has not been initialized")
            Handler(Looper.getMainLooper()).post {
                result.error(
                        "NO_CLIENT",
                        "Client must be initialized before attempting to acquire a token.",
                        null
                )
            }
        }
        //acquire the token
        try {
            val parameters =
                    MSALTokenParametersParser.parse(activity, getAuthCallback(result), args)
            msalApp.acquireToken(parameters)
        } catch (e: MsalException) {
            Log.d(TAG, "MSAL excepton thrown on acquire token")
            handleMsalException(e, result)
        } catch (e: Throwable) {
            Log.d(TAG, "Throwable thrown");
            Handler(Looper.getMainLooper()).post {
                result.error("UNKNOWN", "An unknown error occured.", e.localizedMessage)
            }
        }
    }


    private fun acquireTokenSilent(args: HashMap<String, Any>?, result: MethodChannel.Result) {
        // check if client has been initialized
        if (!isClientInitialized()) {
            Log.d(TAG, "Client has not been initialized")
            Handler(Looper.getMainLooper()).post {
                result.error(
                        "NO_CLIENT",
                        "Client must be initialized before attempting to acquire a token.",
                        null
                )
            }
        }

        //check the scopes
        if (args == null) {
            Log.d(TAG, "no scope")
            Handler(Looper.getMainLooper()).post {
                result.error("NO_SCOPE", "Call must include a scope", null)
            }
            return
        }


        //ensure accounts exist
        if (msalApp is MultipleAccountPublicClientApplication) {
            val accounts = (msalApp as MultipleAccountPublicClientApplication).accounts
            if (accounts.isEmpty()) {
                Log.d(TAG, "no accounts")
                Handler(Looper.getMainLooper()).post {
                    result.error("NO_ACCOUNT", "No accounts exist", null)
                }
                return
            }
        }


        //acquire the token and return the result
        try {
            val account = getAccountFromId(args["accountId"] as String)
            val params = MSALSilentTokenParametersParser.parse(
                    args["tokenParameters"] as HashMap<String, Any>,
                    account as Account,
                    msalApp.configuration.defaultAuthority.authorityURL.toURI().toString(),
                    getAuthCallback(result)
            )
            val authenticationResult = msalApp.acquireTokenSilentAsync(
                    params
            )

        } catch (e: MsalException) {
            handleMsalException(e, result)
        } catch (e: Throwable) {
            Log.d(TAG, "Throwable thrown")
            Handler(Looper.getMainLooper()).post {
                result.error("UNKNOWN", "An unknown error occured.", e.localizedMessage)
            }
        }
    }

    private fun loadAccounts(result: MethodChannel.Result) {
        if (!isClientInitialized()) {
            Log.d(TAG, "Client has not been initialized")
            Handler(Looper.getMainLooper()).post {
                result.error(
                        "NO_CLIENT",
                        "Client must be initialized before attempting to acquire a token.",
                        null
                )
            }
        }
        if (msalApp is MultipleAccountPublicClientApplication) {
            try {
                val accounts = (msalApp as MultipleAccountPublicClientApplication).accounts
                val accountList = ArrayList<HashMap<String, Any?>>()
                for (account in accounts) {
                    accountList.add(MSALAccountParse.parse(account as Account))
                }
                Handler(Looper.getMainLooper()).post {
                    result.success(accountList)
                }
            } catch (e: MsalException) {
                handleMsalException(e, result)
            } catch (e: Throwable) {
                Log.d(TAG, "Throwable thrown")
                Handler(Looper.getMainLooper()).post {
                    result.error("UNKNOWN", "An unknown error occured.", e.localizedMessage)
                }
            }
        } else {
            try {
                val account =
                        (msalApp as SingleAccountPublicClientApplication).currentAccount.currentAccount
                val accountList = ArrayList<HashMap<String, Any?>>()
                accountList.add(MSALAccountParse.parse(account as Account))
                Handler(Looper.getMainLooper()).post {
                    result.success(accountList)
                }
            } catch (e: MsalException) {
                handleMsalException(e, result)
            } catch (e: Throwable) {
                Log.d(TAG, "Throwable thrown")
                Handler(Looper.getMainLooper()).post {
                    result.error("UNKNOWN", "An unknown error occured.", e.localizedMessage)
                }
            }
        }
    }

    // logs out user from all accounts
    private fun logout(args: HashMap<String, Any>?, result: MethodChannel.Result) {
        if (!isClientInitialized()) {
            Log.d(TAG, "Client has not been initialized")
            Handler(Looper.getMainLooper()).post {
                result.error(
                        "NO_CLIENT",
                        "Client must be initialized before attempting to acquire a token.",
                        null
                )
            }
        }
        try
        {
            if (msalApp is MultipleAccountPublicClientApplication && args?.get("accountId") != null) {
                (msalApp as MultipleAccountPublicClientApplication).removeAccount(getAccountFromId(args["accountId"] as String) as Account)
            } else {
                (msalApp as SingleAccountPublicClientApplication).signOut()
            }
            Handler(Looper.getMainLooper()).post {
                result.success(true)
            }
        }
        catch (e: MsalException) {
            handleMsalException(e, result)
        } catch (e: Throwable) {
            Log.d(TAG, "Throwable thrown")
            Handler(Looper.getMainLooper()).post {
                result.error("UNKNOWN", "An unknown error occured.", e.localizedMessage)
            }
        }

    }

    // get the authentication callback object
    private fun getAuthCallback(result: MethodChannel.Result): AuthenticationCallback {
        return object : AuthenticationCallback {
            override fun onSuccess(authenticationResult: IAuthenticationResult) {
                Handler(Looper.getMainLooper()).post {
                    val map = MSALResultParser.parse(authenticationResult as AuthenticationResult)
                    result.success(map)
                }
            }

            override fun onError(exception: MsalException) {
                handleMsalException(exception, result)
            }

            override fun onCancel() {
                Handler(Looper.getMainLooper()).post {
                    result.error("CANCELLED", "User cancelled", "User cancelled")
                }
            }
        }
    }

    private fun getAccountFromId(id: String?): IAccount? {
        if (msalApp is MultipleAccountPublicClientApplication) {
            if (id != null && id.isNotEmpty()) {
                return (msalApp as MultipleAccountPublicClientApplication).getAccount(id)
            }
            val accounts = (msalApp as MultipleAccountPublicClientApplication).accounts
            if (accounts != null && accounts.isNotEmpty()) {
                return accounts[0]
            }
        } else {
            return (msalApp as SingleAccountPublicClientApplication).currentAccount.currentAccount
        }
        throw MsalClientException("No account found")
    }

    // get the application created listener for when initializing new PCA
    private fun getApplicationCreatedListener(result: MethodChannel.Result): IPublicClientApplication.ApplicationCreatedListener {
        Log.d(TAG, "Getting the created listener")
        return object : IPublicClientApplication.ApplicationCreatedListener {


            override fun onCreated(application: IPublicClientApplication?) {
                if (application != null) {


                    msalApp = application

                    Handler(Looper.getMainLooper()).post {
                        result.success(true)
                    }
                } else {
                    Handler(Looper.getMainLooper()).post {
                        result.success(false)
                    }
                }
            }

            override fun onError(exception: MsalException?) {
                if (exception != null) {
                    handleMsalException(exception, result)
                } else {
                    Log.d(TAG, "Error thrown without exception")
                    Handler(Looper.getMainLooper()).post {
                        result.error(
                                "INIT_ERROR", "Error initializting client", exception?.localizedMessage
                        )
                    }
                }
            }
        }
    }

    // converts an azure ad error code to a msal flutter one, and returns error
    private fun handleMsalException(exception: MsalException, result: MethodChannel.Result) {

        val errorCode: String = when (exception.errorCode) {
            "access_denied" -> "CANCELLED"
            "declined_scope_error" -> "SCOPE_ERROR"
            "invalid_request" -> "INVALID_REQUEST"
            "invalid_grant" -> "INVALID_GRANT"
            "unknown_authority" -> "INVALID_AUTHORITY"
            "unknown_error" -> "UNKNOWN"
            else -> "AUTH_ERROR"
        }

        Log.d(TAG, "Msal exception caugth ${exception.errorCode}")
        Log.d(TAG, exception.stackTraceToString())

        //return result
        Handler(Looper.getMainLooper()).post {
            result.error(errorCode, "Authentication failed", exception.localizedMessage)
        }
    }
}