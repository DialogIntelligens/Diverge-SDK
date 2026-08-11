package ai.askdiverge.sdk

import android.content.Context
import android.util.AttributeSet
import android.view.LayoutInflater
import android.widget.LinearLayout
import android.widget.TextView

/**
 * Lightweight status view showing SDK version and configured environment.
 */
class DivergeStatusView @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = 0,
) : LinearLayout(context, attrs, defStyleAttr) {

    private val versionView: TextView
    private val environmentView: TextView
    private val urlView: TextView

    init {
        orientation = VERTICAL
        val padding = (16 * resources.displayMetrics.density).toInt()
        setPadding(padding, padding, padding, padding)
        LayoutInflater.from(context).inflate(R.layout.diverge_status_view, this, true)
        versionView = findViewById(R.id.divergeStatusVersion)
        environmentView = findViewById(R.id.divergeStatusEnvironment)
        urlView = findViewById(R.id.divergeStatusUrl)
        findViewById<TextView>(R.id.divergeStatusTitle).contentDescription =
            context.getString(R.string.diverge_status_title)
        bind(null)
    }

    fun bind(client: DivergeClient?) {
        versionView.text = context.getString(R.string.diverge_status_version, Diverge.VERSION)
        versionView.contentDescription = versionView.text

        if (client != null) {
            val env = client.configuration.environment.wireName
            environmentView.text = context.getString(R.string.diverge_status_environment, env)
            environmentView.contentDescription = environmentView.text
            urlView.text = client.apiBaseUrl
            urlView.contentDescription = "API base URL ${client.apiBaseUrl}"
            urlView.visibility = VISIBLE
        } else {
            environmentView.text = context.getString(R.string.diverge_status_not_configured)
            environmentView.contentDescription = environmentView.text
            urlView.text = ""
            urlView.visibility = GONE
        }
    }

    companion object {
        /** Stable dump for tests (mirrors iOS ``DivergeStatusView.accessibilityDump``). */
        @JvmStatic
        fun accessibilityDump(client: DivergeClient?): String {
            val lines = mutableListOf(
                "title: Diverge SDK",
                "version: ${Diverge.VERSION}",
            )
            if (client != null) {
                lines += "environment: ${client.configuration.environment.wireName}"
                lines += "apiBaseURL: ${client.apiBaseUrl}"
            } else {
                lines += "state: not-configured"
            }
            return lines.joinToString("\n")
        }
    }
}
