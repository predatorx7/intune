package com.hdfc.flutter_plugins.intune_android

import android.app.Activity
import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.NonNull
import com.hdfc.flutter_plugins.intune_android.authentication.AppAccount
import com.hdfc.flutter_plugins.intune_android.authentication.AppSettings
import com.hdfc.flutter_plugins.intune_android.authentication.AppSettings.getAccount
import com.hdfc.flutter_plugins.intune_android.authentication.MAMAuthenticationCallback
import com.hdfc.flutter_plugins.intune_android.authentication.MSALAuthenticationCallback
import com.hdfc.flutter_plugins.intune_android.authentication.MSALUtil
import com.hdfc.flutter_plugins.intune_android.authentication.MSALUtil.acquireToken
import com.hdfc.flutter_plugins.intune_android.authentication.MSALUtil.signOutAccount
import com.hdfc.flutter_plugins.intune_android.msal.MSALConfigParser
import com.hdfc.flutter_plugins.intune_android.msal.MSALFlutterClient
import com.microsoft.identity.client.AcquireTokenParameters
import com.microsoft.identity.client.IPublicClientApplication
import com.microsoft.identity.client.MultipleAccountPublicClientApplication
import com.microsoft.identity.client.Prompt
import com.microsoft.identity.client.exception.MsalException
import com.microsoft.intune.mam.client.app.MAMComponents
import com.microsoft.intune.mam.client.notification.MAMNotificationReceiverRegistry
import com.microsoft.intune.mam.policy.MAMEnrollmentManager
import com.microsoft.intune.mam.policy.notification.MAMEnrollmentNotification
import com.microsoft.intune.mam.policy.notification.MAMNotification
import com.microsoft.intune.mam.policy.notification.MAMNotificationType
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import java.util.UUID


/** IntuneAndroidPlugin */
class IntuneAndroidPlugin : FlutterPlugin, IntuneApi, ActivityAware {
    companion object {
        const val TAG = "IntuneAndroidPlugin"

        private fun getEnrollmentManager(): MAMEnrollmentManager? {
            return MAMComponents.get(MAMEnrollmentManager::class.java);
        }

        private fun getNotificationRegistry(): MAMNotificationReceiverRegistry? {
            return MAMComponents.get(MAMNotificationReceiverRegistry::class.java)
        }
    }

    private lateinit var context: Context
    private lateinit var reply: IntuneReply
    private var activity: Activity? = null
    private var msalPublicClientApplication: IPublicClientApplication? = null

    private fun setup(messenger: BinaryMessenger, context: Context) {
        try {
            IntuneApi.setUp(messenger, this)
        } catch (ex: Error) {
            Log.e(TAG, "Received exception while setting up IntuneAndroidPlugin", ex);
        }

        try {
            reply = IntuneReply(messenger)
        } catch (ex: Error) {
            Log.e(TAG, "Received exception while setting up IntuneFlutterApi", ex);
        }

        this.context = context;
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        setup(flutterPluginBinding.binaryMessenger, flutterPluginBinding.applicationContext);
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        IntuneApi.setUp(binding.binaryMessenger, null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity;
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null;
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity;
    }

    override fun onDetachedFromActivity() {
        activity = null;
    }

    override fun registerAuthentication(callback: (kotlin.Result<Boolean>) -> Unit) {
        callback(kotlin.Result.success(registerAuthentication()));
    }

    private fun registerAuthentication(): Boolean {
        // Registers a MAMAuthenticationCallback, which will try to acquire access tokens for MAM.
        // This is necessary for proper MAM integration.
        // Registers a MAMAuthenticationCallback, which will try to acquire access tokens for MAM.
        // This is necessary for proper MAM integration.
        val mgr = getEnrollmentManager() ?: return false
        mgr.registerAuthenticationCallback(MAMAuthenticationCallback(intuneFlutterApi))

        /* This section shows how to register a MAMNotificationReceiver, so you can perform custom
             * actions based on MAM enrollment notifications.
             * More information is available here:
             * https://docs.microsoft.com/en-us/intune/app-sdk-android#types-of-notifications */

        /* This section shows how to register a MAMNotificationReceiver, so you can perform custom
             * actions based on MAM enrollment notifications.
             * More information is available here:
             * https://docs.microsoft.com/en-us/intune/app-sdk-android#types-of-notifications */
        val notificationRegistry = getNotificationRegistry()!!
        notificationRegistry.registerReceiver({ notification: MAMNotification? ->
            if (notification is MAMEnrollmentNotification) {
                when (val result = notification.enrollmentResult) {
                    MAMEnrollmentManager.Result.AUTHORIZATION_NEEDED, MAMEnrollmentManager.Result.NOT_LICENSED, MAMEnrollmentManager.Result.ENROLLMENT_SUCCEEDED, MAMEnrollmentManager.Result.ENROLLMENT_FAILED, MAMEnrollmentManager.Result.WRONG_USER, MAMEnrollmentManager.Result.UNENROLLMENT_SUCCEEDED, MAMEnrollmentManager.Result.UNENROLLMENT_FAILED, MAMEnrollmentManager.Result.PENDING, MAMEnrollmentManager.Result.COMPANY_PORTAL_REQUIRED -> reply.onEnrollmentNotification(result.name)
                    else -> reply.onEnrollmentNotification(result.name)
                }
            } else {
                reply.onUnexpectedEnrollmentNotification()
            }
            true
        }, MAMNotificationType.MAM_ENROLLMENT_RESULT)

        return true;
    }

    override fun registerAccountForMAM(upn: String, aadId: String, tenantId: String, authorityURL: String, callback: (kotlin.Result<Boolean>) -> Unit) {
        callback(kotlin.Result.success(registerAccountForMAM(upn, aadId, tenantId, authorityURL)));
    }

    private fun registerAccountForMAM(upn: String, aadId: String, tenantId: String, authorityURL: String): Boolean {
        val mEnrollmentManager = getEnrollmentManager() ?: return false
        // Register the account for MAM.
        mEnrollmentManager.registerAccountForMAM(upn, aadId, tenantId, authorityURL);
        return true
    }

    override fun unregisterAccountFromMAM(upn: String, aadId: String, callback: (kotlin.Result<Boolean>) -> Unit) {
        callback(kotlin.Result.success(unregisterAccountFromMAM(upn, aadId)));
    }

    private fun unregisterAccountFromMAM(upn: String, aadId: String): Boolean {
        val mEnrollmentManager = getEnrollmentManager() ?: return false
        mEnrollmentManager.unregisterAccountForMAM(upn, aadId);
        return true
    }

    private fun getUserAccount(): AppAccount? {
        // Get the account info from the app settings.
        // If a user is not signed in, the account will be null.

        // Get the account info from the app settings.
        // If a user is not signed in, the account will be null.
        return getAccount(context)
    }

    override fun createMicrosoftPublicClientApplication(publicClientApplicationConfiguration: Map<String, Any?>, enableLogs: Boolean, callback: (kotlin.Result<Boolean>) -> Unit) {
        try {
            val msalLogger = com.microsoft.identity.client.Logger.getInstance()
            msalLogger.setEnableLogcatLog(true)
            msalLogger.setLogLevel(com.microsoft.identity.client.Logger.LogLevel.VERBOSE)
            msalLogger.setEnablePII(true)
            // Key-values that match PublicClientApplicationConfiguration's properties
            val configFile = MSALConfigParser.parse(publicClientApplicationConfiguration)
            val applicationCreatedListener = object : IPublicClientApplication.ApplicationCreatedListener {
                override fun onCreated(application: IPublicClientApplication?) {
                    if (application != null) {
                        msalPublicClientApplication = application
                        Handler(Looper.getMainLooper()).post {
                            callback(Result.success(true))
                        }
                    } else {
                        Handler(Looper.getMainLooper()).post {
                            callback(Result.success(false))
                        }
                    }
                }

                override fun onError(exception: MsalException?) {
                    Log.e(MSALFlutterClient.TAG, "createMicrosoftPublicClientApplication", exception)
                    if (exception != null) {
                        Handler(Looper.getMainLooper()).post {
                            reply.onMsalException(exception)
                            callback(Result.failure(exception))
                        }
                    } else {
                        Log.d(MSALFlutterClient.TAG, "Error thrown without exception")
                        Handler(Looper.getMainLooper()).post {
                            callback(Result.failure(UnknownError()))
                        }
                    }
                }
            }

            MultipleAccountPublicClientApplication.create(
                context, configFile, applicationCreatedListener,
            )
        } catch (e: Throwable) {
            Log.e(MSALFlutterClient.TAG, "Failed to initialize", e)
            callback(Result.failure(e))
        }
    }

    override fun signIn(params: SignInParams, callback: (kotlin.Result<Boolean>) -> Unit) {
        val app = msalPublicClientApplication

        val mUserAccount = getUserAccount()

        // initiate the MSAL authentication on a background thread
        // initiate the MSAL authentication on a background thread
        val thread = Thread {
            Log.i(TAG, "signIn: Starting interactive auth")
            if (app == null) {
                callback(Result.success(false))
                return@Thread
            }

            try {
                var loginHint: String? = null
                if (mUserAccount != null) {
                    loginHint = mUserAccount.upn
                }
                val authCallback = MSALAuthenticationCallback(context, intuneFlutterApi, getEnrollmentManager()!!)
                var paramsBuilder = AcquireTokenParameters.Builder()
                        .withScopes(params.scopes)
                        .withCallback(authCallback)
                        .startAuthorizationFromActivity(activity!!)
                        .withLoginHint(loginHint)
                if (params.authority != null) {
                    paramsBuilder = paramsBuilder.fromAuthority(params.authority)
                }
                if (params.correlationId != null) {
                    paramsBuilder = paramsBuilder.withCorrelationId(UUID.fromString(params.correlationId))
                }
                if (params.loginHint != null) {
                    paramsBuilder = paramsBuilder.withLoginHint(params.loginHint)
                }
                if (params.prompt != null) {
                    paramsBuilder = paramsBuilder.withPrompt(when (params.prompt) {
                        MSALLoginPrompt.CONSENT -> Prompt.CONSENT
                        MSALLoginPrompt.CREATE -> Prompt.CREATE
                        MSALLoginPrompt.LOGIN -> Prompt.LOGIN
                        MSALLoginPrompt.SELECTACCOUNT -> Prompt.SELECT_ACCOUNT
                        MSALLoginPrompt.WHENREQUIRED -> Prompt.WHEN_REQUIRED
                    })
                }
                if (params.extraScopesToConsent != null) {
                    paramsBuilder = paramsBuilder.withOtherScopesToAuthorize(params.extraScopesToConsent)
                }
                app.acquireToken(paramsBuilder.build())
                callback(Result.success(true))
            } catch (e: MsalException) {
                Log.e(TAG, "signIn: Failed MSAL sign in", e)
                Handler(Looper.getMainLooper()).post {
                    callback(Result.failure(e))
                }
            } catch (e: InterruptedException) {
                Log.e(TAG,"signIn: Failed MSAL sign in", e)
                Handler(Looper.getMainLooper()).post {
                    callback(Result.failure(e))
                }
            } catch (e: Throwable) {
                Handler(Looper.getMainLooper()).post {
                    callback(Result.failure(e))
                }
            }
        }
        thread.start()
    }

    fun signOut() {
        // Initiate an MSAL sign out on a background thread.
        val effectiveAccount: AppAccount = getUserAccount() ?: return
        val thread = Thread {
            try {
                signOutAccount(context, effectiveAccount.aadid)
            } catch (e: MsalException) {
                Log.e(TAG,"signOut: Failed to sign out user ${effectiveAccount.aadid}", e)
            } catch (e: InterruptedException) {
                Log.e(TAG,"signOut: Failed to sign out user ${effectiveAccount.aadid}", e)
            }
            val mEnrollmentManager = getEnrollmentManager()
            mEnrollmentManager?.unregisterAccountForMAM(effectiveAccount.upn, effectiveAccount.aadid)
            AppSettings.clearAccount(context)
        }
        thread.start()
    }
}
