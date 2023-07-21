package com.hdfc.flutter_plugins.intune_android.authentication

import android.content.SharedPreferences


/**
 * Represents an account that is signed in to the app.
 */
class AppAccount(
    /**
     * Get the UPN.
     *
     * @return the UPN.
     */
    val upn: String,
    /**
     * Get the account ID.
     *
     * @return the account ID.
     */
    val aadid: String,
    /**
     * Get the tenant ID.
     *
     * @return the tenant ID.
     */
    val tenantID: String,
    /**
     * Get the Authority used to sign in the account.
     *
     * @return the Authority.
     */
    val authority: String,
) {

    /**
     * The Account should save itself to the provided SharedPreferences object.
     *
     * @param sharedPref
     * the preferences where the account should be written.
     */
    fun saveToSettings(sharedPref: SharedPreferences) {
        val editor = sharedPref.edit()
        editor.putString(UPN_KEY, upn)
        editor.putString(AADID_KEY, aadid)
        editor.putString(TENANTID_KEY, tenantID)
        editor.putString(AUTHORITY_KEY, authority)
        editor.apply()
    }

    companion object {
        private const val UPN_KEY = "mam.appaccount.upn"
        private const val AADID_KEY = "mam.appaccount.aadid"
        private const val TENANTID_KEY = "mam.appaccount.tenantid"
        private const val AUTHORITY_KEY = "mam.appaccount.authority"

        /**
         * Reconstitute the account object from the provided settings, where it was
         * previously saved.
         *
         * @param sharedPref
         * the preferences.
         *
         * @return the reconstituted account object, or null if insufficient data was
         * found in the settings.
         */
        fun readFromSettings(sharedPref: SharedPreferences): AppAccount? {
            val upn = sharedPref.getString(UPN_KEY, null) ?: return null
            val aadid = sharedPref.getString(AADID_KEY, null) ?: return null
            val tenantid = sharedPref.getString(TENANTID_KEY, null) ?: return null
            val authority = sharedPref.getString(AUTHORITY_KEY, null)
                    ?: return null
            return AppAccount(upn, aadid, tenantid, authority)
        }

        /**
         * Clear the saved account data from the provided settings object.
         *
         * @param sharedPref
         * the settings from which the account data should be cleared.
         */
        fun clearFromSettings(sharedPref: SharedPreferences) {
            val editor = sharedPref.edit()
            editor.remove(UPN_KEY)
            editor.remove(AADID_KEY)
            editor.remove(TENANTID_KEY)
            editor.remove(AUTHORITY_KEY)
            editor.apply()
        }
    }
}
