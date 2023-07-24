package com.hdfc.flutter_plugins.intune_android

import android.app.Activity
import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.microsoft.identity.client.AcquireTokenParameters
import com.microsoft.identity.client.IAuthenticationResult
import com.microsoft.identity.client.IMultipleAccountPublicClientApplication
import com.microsoft.identity.client.IMultipleAccountPublicClientApplication.RemoveAccountCallback
import com.microsoft.identity.client.IPublicClientApplication
import com.microsoft.identity.client.ISingleAccountPublicClientApplication
import com.microsoft.identity.client.MultipleAccountPublicClientApplication
import com.microsoft.identity.client.Prompt
import com.microsoft.identity.client.exception.MsalException
import com.microsoft.intune.mam.client.app.MAMComponents
import com.microsoft.intune.mam.client.notification.MAMNotificationReceiverRegistry
import com.microsoft.intune.mam.policy.MAMEnrollmentManager
import com.microsoft.intune.mam.policy.MAMServiceAuthenticationCallback
import com.microsoft.intune.mam.policy.notification.MAMEnrollmentNotification
import com.microsoft.intune.mam.policy.notification.MAMNotification
import com.microsoft.intune.mam.policy.notification.MAMNotificationType
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import java.util.UUID
import java.util.logging.Level
import java.util.logging.Logger


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
    private var publicClientApplication: IPublicClientApplication? = null

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
        val app = publicClientApplication
        if (app == null) {
            Logger.getLogger("registerAuthentication").warning("PUBLIC CLIENT APP NOT INITIALIZED")
            return false
        }
        // Registers a MAMAuthenticationCallback, which will try to acquire access tokens for MAM.
        // This is necessary for proper MAM integration.
        // Registers a MAMAuthenticationCallback, which will try to acquire access tokens for MAM.
        // This is necessary for proper MAM integration.
        val mgr = getEnrollmentManager() ?: return false

        mgr.registerAuthenticationCallback(object  : MAMServiceAuthenticationCallback {
            override fun acquireToken(upn: String, aadId: String, resourceId: String): String? {
                val logger = Logger.getLogger("registerAuthenticationCallback")
                try {
                    // Create the MSAL scopes by using the default scope of the passed in resource id.
                    val scopes = arrayListOf("$resourceId/.default")
                    val accessToken = IntuneUtils(app, reply).acquireTokenSilent(upn, aadId, scopes)
                    if (accessToken != null) return accessToken
                } catch (e: Throwable) {
                    logger.log(Level.SEVERE, "Failed to get token for MAM Service", e)
                    return null
                }
                logger.warning("Failed to get token for MAM Service - no result from MSAL")
                return null
            }
        })

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

    override fun getAccounts(aadId: String?, callback: (Result<List<MSALUserAccount?>>) -> Unit) {
        val app = publicClientApplication
       try {
            if (app is IMultipleAccountPublicClientApplication) {
                val accounts = app.accounts.map { account ->
                    {
                        MSALUserAccount(
                                authority = account.authority,
                                id = account.id,
                                tenantId = account.tenantId,
                                username = account.username,
                        )
                    }
                }.map { it() }
                return callback(Result.success(accounts))
            } else if (app is ISingleAccountPublicClientApplication) {
                val account = app.currentAccount?.currentAccount
                if (account != null) {
                    return callback(Result.success(listOf(MSALUserAccount(
                            authority = account.authority,
                            id = account.id,
                            tenantId = account.tenantId,
                            username = account.username,
                    ))))
                }
            }
            return callback(Result.failure(UnknownError()))
        } catch (e: Throwable) {
           Log.e(TAG, "Failed to get accounts", e)
           return callback(Result.failure(e))
        }
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
                        publicClientApplication = application
                        callback(Result.success(true))
                    } else {
                        callback(Result.success(false))
                    }
                }

                override fun onError(exception: MsalException?) {
                    reply.onMsalException(exception)
                    if (exception != null) {
                        callback(Result.failure(exception))
                    } else {
                        Log.d(TAG, "Error thrown without exception")
                        callback(Result.failure(UnknownError()))
                    }
                }
            }

            MultipleAccountPublicClientApplication.create(
                context, configFile, applicationCreatedListener,
            )
        } catch (e: Throwable) {
            Log.e(TAG, "Failed to initialize", e)
            callback(Result.failure(e))
        }
    }

    override fun signIn(params: SignInParams, callback: (kotlin.Result<Boolean>) -> Unit) {
        val app = publicClientApplication

        Log.i(TAG, "signIn: Starting interactive auth")
        if (app == null) {
            Log.i(TAG, "signIn: Initialize public client application required")
            callback(Result.success(false))
            return
        }

        try {
            var paramsBuilder = AcquireTokenParameters.Builder()
                    .withScopes(params.scopes)
                    .withCallback(object  : com.microsoft.identity.client.AuthenticationCallback {

                        override fun onError(exc: MsalException?) {
                            reply.onMsalException(exc)
                        }

                        override fun onSuccess(result: IAuthenticationResult) {
                            return reply.onMSALAuthenticationResult(result)
                        }

                        override fun onCancel() {
                            reply.onErrorType(MSALErrorType.USERCANCELLEDSIGNINREQUEST)
                        }
                    })
                    .startAuthorizationFromActivity(activity!!)
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
            callback(Result.failure(e))
        } catch (e: InterruptedException) {
            Log.e(TAG,"signIn: Failed MSAL sign in", e)
            callback(Result.failure(e))
        } catch (e: Throwable) {
            callback(Result.failure(e))
        }
    }

    override fun signOut(aadId: String?, callback: (kotlin.Result<Boolean>) -> Unit) {
        // Initiate an MSAL sign out on a background thread.
        val app = publicClientApplication
        if (app is ISingleAccountPublicClientApplication) {
            app.signOut(object: ISingleAccountPublicClientApplication.SignOutCallback {
                override fun onSignOut() {
                    callback(Result.success(true))
                    Log.i(TAG,"signOut: complete")
                }

                override fun onError(exception: MsalException) {
                    callback(Result.success(false))
                    reply.onMsalException(exception)
                }
            })
            return
        } else if (app is IMultipleAccountPublicClientApplication) {
            val account = if (aadId == null) {
                app.accounts.firstOrNull()
            } else {
                app.getAccount(aadId)
            }
            app.removeAccount(account, object : RemoveAccountCallback {
                override fun onRemoved() {
                    callback(Result.success(true))
                    Log.i(TAG,"signOut: complete")
                }

                override fun onError(exception: MsalException) {
                    callback(Result.success(false))
                    reply.onMsalException(exception)
                }
            })
        } else {
            Log.i(TAG,"signOut: unknown account type")
            callback(Result.success(false))
        }
    }
}
